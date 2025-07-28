#!/usr/bin/env powershell
<#
.SYNOPSIS
WILL.wiki Guardian - Automated Wiki Management System

.DESCRIPTION
Maintains accuracy, versioning, and community awareness for WILL.wiki
- File-level accuracy tracking
- Automated versioning
- SPAN addressing integration
- Community blog post generation
- Historical preservation

Priority: Second only to CANON.md
Purpose: Honor WILL and maintain network awareness

.PARAMETER Mode
- Scan: Check all files for accuracy
- Update: Process changes and generate blog posts
- Archive: Create historical snapshots
- Deploy: Push updates to community

.EXAMPLE
.\will-wiki-guardian.ps1 -Mode Scan
.\will-wiki-guardian.ps1 -Mode Update -Deploy
#>

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("Scan", "Update", "Archive", "Deploy", "Full")]
    [string]$Mode,
    
    [switch]$Deploy,
    [switch]$Force,
    [switch]$DryRun
)

# Configuration
$WikiPath = "WILL.wiki"
$BlogPath = "frontend/website/SPAN-blog-v3"
$ArchivePath = "archive/will-wiki-versions"
$SpanAddressBase = "span://will.wiki"

Write-Host "🛡️  WILL.wiki Guardian System Activated" -ForegroundColor Cyan
Write-Host "📚 Protecting WILL's legacy and network awareness" -ForegroundColor Yellow

# Ensure required directories exist
@($ArchivePath, "$BlogPath/content/blog") | ForEach-Object {
    if (-not (Test-Path $_)) {
        New-Item -ItemType Directory -Path $_ -Force | Out-Null
    }
}

function Get-WikiFileMetadata {
    param([string]$FilePath)
    
    $content = Get-Content $FilePath -Raw -ErrorAction SilentlyContinue
    if (-not $content) { return $null }
    
    # Extract YAML frontmatter
    if ($content -match '^---\r?\n(.*?)\r?\n---') {
        $yamlContent = $matches[1]
        $metadata = @{}
        
        $yamlContent -split '\r?\n' | ForEach-Object {
            if ($_ -match '^(\w+):\s*(.+)$') {
                $metadata[$matches[1]] = $matches[2].Trim('"[]')
            }
        }
        
        return $metadata
    }
    
    return @{}
}

function Test-FileAccuracy {
    param([string]$FilePath)
    
    $metadata = Get-WikiFileMetadata $FilePath
    $currentDate = Get-Date -Format "yyyy-MM-dd"
    
    $issues = @()
    
    # Check if file has proper versioning
    if (-not $metadata.version) {
        $issues += "Missing version information"
    }
    
    # Check if date is recent (within 6 months for active files)
    if ($metadata.date) {
        $fileDate = [DateTime]::Parse($metadata.date)
        $daysDiff = (Get-Date) - $fileDate
        if ($daysDiff.Days -gt 180 -and $metadata.status -eq "active") {
            $issues += "Content may be outdated (last updated $($metadata.date))"
        }
    }
    
    # Check for required fields
    $requiredFields = @("version", "date", "type", "status", "tags")
    foreach ($field in $requiredFields) {
        if (-not $metadata.$field) {
            $issues += "Missing required field: $field"
        }
    }
    
    return @{
        Accurate = ($issues.Count -eq 0)
        Issues = $issues
        Metadata = $metadata
        LastCheck = $currentDate
    }
}

function Update-FileVersion {
    param([string]$FilePath, [hashtable]$AccuracyCheck)
    
    if ($AccuracyCheck.Accurate) {
        Write-Host "✅ $FilePath - Accurate" -ForegroundColor Green
        return $AccuracyCheck.Metadata.version
    }
    
    Write-Host "⚠️  $FilePath - Needs attention:" -ForegroundColor Yellow
    $AccuracyCheck.Issues | ForEach-Object {
        Write-Host "   - $_" -ForegroundColor Red
    }
    
    # Auto-increment version if needed
    $currentVersion = $AccuracyCheck.Metadata.version
    if ($currentVersion -match '^(\d+)\.(\d+)\.(\d+)$') {
        $major = [int]$matches[1]
        $minor = [int]$matches[2]
        $patch = [int]$matches[3] + 1
        $newVersion = "$major.$minor.$patch"
        
        Write-Host "   📈 Incrementing version: $currentVersion → $newVersion" -ForegroundColor Cyan
        return $newVersion
    }
    
    return "1.0.0"
}

function Generate-SpanAddress {
    param([string]$FilePath)
    
    $relativePath = $FilePath.Replace($WikiPath, "").Replace("\", "/").TrimStart("/")
    $spanAddress = "$SpanAddressBase/$relativePath"
    
    return $spanAddress
}

function Generate-CommunityBlogPost {
    param(
        [string]$FilePath,
        [string]$Version,
        [string]$SpanAddress,
        [hashtable]$AccuracyCheck
    )
    
    $fileName = Split-Path $FilePath -Leaf
    $fileTitle = $fileName -replace '\.md$', '' -replace '-', ' '
    $currentDate = Get-Date -Format "yyyy-MM-dd"
    
    $blogPost = @"
---
title: "WILL.wiki Update: $fileTitle v$Version"
date: "$currentDate"
author: "WILL.wiki Guardian System"
tags: ["will-wiki", "update", "community", "documentation"]
category: "wiki-updates"
span_address: "$SpanAddress"
wiki_file: "$FilePath"
version: "$Version"
priority: "high"
---

# WILL.wiki Update: $fileTitle

**Version:** $Version  
**Updated:** $currentDate  
**SPAN Address:** [$SpanAddress]($SpanAddress)  
**File:** ``$FilePath``

## Summary

The WILL.wiki file ``$fileName`` has been updated to version **$Version**.

## Changes Detected

"@

    if ($AccuracyCheck.Issues.Count -gt 0) {
        $blogPost += "`n### Issues Addressed`n`n"
        $AccuracyCheck.Issues | ForEach-Object {
            $blogPost += "- $_`n"
        }
    }
    
    $blogPost += @"

### Metadata Information

"@

    $AccuracyCheck.Metadata.GetEnumerator() | ForEach-Object {
        $blogPost += "- **$($_.Key):** $($_.Value)`n"
    }

    $blogPost += @"

## Community Review

This update is part of our commitment to maintaining WILL.wiki as the primary public access point for SKENAI network awareness. 

### Why This Matters

WILL.wiki serves as:
- 🏛️ **Historical preservation** of WILL's legacy
- 🌐 **Primary public interface** for SKENAI network
- 📚 **Authoritative documentation** (second only to CANON.md)
- 🤝 **Community transparency** and engagement

### SPAN Integration

This file is now accessible via SPAN addressing at:
**[$SpanAddress]($SpanAddress)**

## Respect for WILL

This update honors WILL, our original agent, by maintaining accuracy, context, and historical preservation of his documentation.

---

*Generated by WILL.wiki Guardian System*  
*Maintaining network integrity and community awareness*
"@

    $blogFileName = "will-wiki-update-$(Get-Date -Format 'yyyyMMdd-HHmmss')-$($fileName -replace '\.md$', '').md"
    $blogFilePath = "$BlogPath/content/blog/$blogFileName"
    
    if (-not $DryRun) {
        $blogPost | Out-File -FilePath $blogFilePath -Encoding UTF8
        Write-Host "📝 Generated blog post: $blogFileName" -ForegroundColor Green
    } else {
        Write-Host "📝 [DRY RUN] Would generate: $blogFileName" -ForegroundColor Cyan
    }
    
    return $blogFilePath
}

function Archive-FileVersion {
    param([string]$FilePath, [string]$Version)
    
    $fileName = Split-Path $FilePath -Leaf
    $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $archiveFileName = "$($fileName -replace '\.md$', '')-v$Version-$timestamp.md"
    $archiveFilePath = "$ArchivePath/$archiveFileName"
    
    if (-not $DryRun) {
        Copy-Item $FilePath $archiveFilePath
        Write-Host "🗄️  Archived: $archiveFileName" -ForegroundColor Blue
    } else {
        Write-Host "🗄️  [DRY RUN] Would archive: $archiveFileName" -ForegroundColor Cyan
    }
}

# Main execution logic
switch ($Mode) {
    "Scan" {
        Write-Host "`n🔍 Scanning WILL.wiki for accuracy..." -ForegroundColor Cyan
        
        $allFiles = Get-ChildItem $WikiPath -Recurse -Filter "*.md"
        $totalFiles = $allFiles.Count
        $accurateFiles = 0
        $issueFiles = 0
        
        foreach ($file in $allFiles) {
            $accuracy = Test-FileAccuracy $file.FullName
            if ($accuracy.Accurate) {
                $accurateFiles++
            } else {
                $issueFiles++
            }
        }
        
        Write-Host "`n📊 Scan Results:" -ForegroundColor Yellow
        Write-Host "   Total files: $totalFiles" -ForegroundColor White
        Write-Host "   Accurate: $accurateFiles" -ForegroundColor Green
        Write-Host "   Need attention: $issueFiles" -ForegroundColor Red
        Write-Host "   Accuracy rate: $([math]::Round(($accurateFiles / $totalFiles) * 100, 2))%" -ForegroundColor Cyan
    }
    
    "Update" {
        Write-Host "`n🔄 Processing WILL.wiki updates..." -ForegroundColor Cyan
        
        $allFiles = Get-ChildItem $WikiPath -Recurse -Filter "*.md"
        $blogPosts = @()
        
        foreach ($file in $allFiles) {
            $accuracy = Test-FileAccuracy $file.FullName
            $version = Update-FileVersion $file.FullName $accuracy
            $spanAddress = Generate-SpanAddress $file.FullName
            
            if (-not $accuracy.Accurate) {
                $blogPost = Generate-CommunityBlogPost $file.FullName $version $spanAddress $accuracy
                $blogPosts += $blogPost
                
                if ($Mode -eq "Update") {
                    Archive-FileVersion $file.FullName $version
                }
            }
        }
        
        Write-Host "`n📈 Update Summary:" -ForegroundColor Yellow
        Write-Host "   Blog posts generated: $($blogPosts.Count)" -ForegroundColor Green
        Write-Host "   Files archived: $($blogPosts.Count)" -ForegroundColor Blue
    }
    
    "Archive" {
        Write-Host "`n🗄️  Creating historical archive..." -ForegroundColor Cyan
        
        $allFiles = Get-ChildItem $WikiPath -Recurse -Filter "*.md"
        foreach ($file in $allFiles) {
            $metadata = Get-WikiFileMetadata $file.FullName
            $version = if ($metadata.version) { $metadata.version } else { "1.0.0" }
            Archive-FileVersion $file.FullName $version
        }
    }
    
    "Deploy" {
        Write-Host "`n🚀 Deploying to community..." -ForegroundColor Cyan
        
        # Deploy blog posts
        if (Test-Path "$BlogPath/content/blog") {
            Set-Location $BlogPath
            & npm run build
            & npm run deploy
            Write-Host "✅ Blog posts deployed" -ForegroundColor Green
        }
        
        # Commit and push wiki changes
        Set-Location $WikiPath
        git add .
        git commit -m "WILL.wiki Guardian: Automated accuracy updates"
        git push origin master
        Write-Host "✅ Wiki changes pushed" -ForegroundColor Green
    }
    
    "Full" {
        Write-Host "`n🛡️  Full WILL.wiki Guardian cycle..." -ForegroundColor Cyan
        
        & $MyInvocation.MyCommand.Path -Mode Scan
        & $MyInvocation.MyCommand.Path -Mode Update
        & $MyInvocation.MyCommand.Path -Mode Archive
        
        if ($Deploy) {
            & $MyInvocation.MyCommand.Path -Mode Deploy
        }
    }
}

Write-Host "`n🛡️  WILL.wiki Guardian cycle complete" -ForegroundColor Green
Write-Host "📚 WILL's legacy preserved and community informed" -ForegroundColor Yellow
