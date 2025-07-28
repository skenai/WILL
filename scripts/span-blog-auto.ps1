#!/usr/bin/env powershell
<#
.SYNOPSIS
    SPAN Blog Auto-Generation for WILL.wiki Updates
    
.DESCRIPTION
    Automatically generates professional blog posts for WILL.wiki updates
    Integrates with SPAN-blog-v5 and existing blog infrastructure
    Maintains community awareness and transparency
    
.PARAMETER WikiFile
    Specific wiki file that was updated
    
.PARAMETER UpdateType
    Type of update: New, Modified, Version, Emergency
    
.PARAMETER Deploy
    Deploy blog post immediately after generation
    
.EXAMPLE
    .\span-blog-auto.ps1 -WikiFile "guides/Contributing.md" -UpdateType "Modified" -Deploy
#>

param(
    [string]$WikiFile,
    [ValidateSet("New", "Modified", "Version", "Emergency", "Batch")]
    [string]$UpdateType = "Modified",
    [switch]$Deploy,
    [switch]$BatchMode
)

# SPAN Blog Configuration
$BlogPath = "frontend/website/SPAN-blog-v5"
$BlogContentPath = "$BlogPath/content/blog"
$WikiPath = "WILL.wiki"
$SpanNetwork = "skenai"

Write-Host "[BLOG] SPAN Blog Auto-Generator for WILL.wiki" -ForegroundColor Cyan
Write-Host "[TARGET] Maintaining community awareness and transparency" -ForegroundColor Green

function Get-WikiMetadata {
    param([string]$FilePath)
    
    if (-not (Test-Path $FilePath)) {
        return @{
            title = "Unknown"
            version = "1.0.0"
            description = "WILL.wiki update"
            lastUpdated = Get-Date -Format "yyyy-MM-dd"
        }
    }
    
    $content = Get-Content $FilePath -Raw
    $metadata = @{
        title = "WILL.wiki Update"
        version = "1.0.0"
        description = "Knowledge base update"
        lastUpdated = Get-Date -Format "yyyy-MM-dd"
    }
    
    # Extract frontmatter
    if ($content -match '(?s)^---\s*\n(.*?)\n---') {
        $frontmatter = $matches[1]
        
        if ($frontmatter -match 'title:\s*(.+)') {
            $metadata.title = $matches[1].Trim('"').Trim("'")
        }
        if ($frontmatter -match 'version:\s*(.+)') {
            $metadata.version = $matches[1].Trim('"').Trim("'")
        }
        if ($frontmatter -match 'description:\s*(.+)') {
            $metadata.description = $matches[1].Trim('"').Trim("'")
        }
        if ($frontmatter -match 'last_updated:\s*(.+)') {
            $metadata.lastUpdated = $matches[1].Trim('"').Trim("'")
        }
    }
    
    return $metadata
}

function Generate-BlogPost {
    param(
        [string]$WikiFile,
        [string]$UpdateType,
        [object]$Metadata
    )
    
    $timestamp = Get-Date -Format "yyyy-MM-dd-HHmm"
    $blogFileName = "will-wiki-update-$timestamp.md"
    $blogFilePath = "$BlogContentPath/$blogFileName"
    
    # Ensure blog directory exists
    if (-not (Test-Path $BlogContentPath)) {
        New-Item -ItemType Directory -Path $BlogContentPath -Force | Out-Null
    }
    
    # Generate SPAN address for the wiki file
    $spanAddress = "span://$SpanNetwork/wiki/will/$($WikiFile -replace '\.md$', '' -replace '\\', '/')"
    
    # Create blog post content using string concatenation
    $blogContent = "---`n"
    $blogContent += "title: `"WILL.wiki Update: $($Metadata.title)`"`n"
    $blogContent += "date: $(Get-Date -Format 'yyyy-MM-ddTHH:mm:ss.fffZ')`n"
    $blogContent += "author: `"WILL Guardian System`"`n"
    $blogContent += "tags: [`"will-wiki`", `"knowledge-base`", `"skenai`", `"update`"]`n"
    $blogContent += "category: `"Network Updates`"`n"
    $blogContent += "description: `"$($Metadata.description) - WILL.wiki knowledge base update`"`n"
    $blogContent += "span_address: `"$spanAddress`"`n"
    $blogContent += "update_type: `"$UpdateType`"`n"
    $blogContent += "wiki_version: `"$($Metadata.version)`"`n"
    $blogContent += "---`n`n"
    $blogContent += "# WILL.wiki Knowledge Base Update`n`n"
    $blogContent += "**Update Type:** $UpdateType`n"
    $blogContent += "**File:** $WikiFile`n"
    $blogContent += "**Version:** $($Metadata.version)`n"
    $blogContent += "**Date:** $(Get-Date -Format 'MMMM dd, yyyy')`n`n"
    $blogContent += "## What's New`n`n"
    $blogContent += "The WILL.wiki knowledge base has been updated with important information. "
    $blogContent += "As the original SKENAI agent's primary knowledge repository, WILL.wiki serves as the second most important public access point after CANON.md.`n`n"
    $blogContent += "### Updated Content`n`n"
    $blogContent += "**File:** [$($Metadata.title)]($spanAddress)`n"
    $blogContent += "**Description:** $($Metadata.description)`n`n"
    $blogContent += "### Key Changes`n`n"

    # Add specific content based on update type
    switch ($UpdateType) {
        "New" {
            $blogContent += "`n[NEW] **New Knowledge Added**`n"
            $blogContent += "- Fresh content has been added to the WILL.wiki knowledge base`n"
            $blogContent += "- This expansion enhances the public understanding of the SKENAI network`n"
            $blogContent += "- Community access to critical information has been improved`n`n"
        }
        "Modified" {
            $blogContent += "`n[UPDATED] **Content Updated**`n"
            $blogContent += "- Existing knowledge has been refined and improved`n"
            $blogContent += "- Information accuracy has been enhanced`n"
            $blogContent += "- Community understanding benefits from these improvements`n`n"
        }
        "Version" {
            $blogContent += "`n[VERSION] **Version Update**`n"
            $blogContent += "- Knowledge base version has been incremented to v$($Metadata.version)`n"
            $blogContent += "- Systematic improvements and refinements applied`n"
            $blogContent += "- Historical preservation maintained through versioning`n`n"
        }
        "Emergency" {
            $blogContent += "`n[EMERGENCY] **Emergency Update**`n"
            $blogContent += "- Critical information has been updated immediately`n"
            $blogContent += "- Network integrity and accuracy maintained`n"
            $blogContent += "- Community notification prioritized for transparency`n`n"
        }
        "Batch" {
            $blogContent += "`n[BATCH] **Batch Update**`n"
            $blogContent += "- Multiple files have been updated simultaneously`n"
            $blogContent += "- Comprehensive knowledge base improvements`n"
            $blogContent += "- Coordinated enhancement of community resources`n`n"
        }
    }

    $blogContent += "`n## About WILL.wiki`n`n"
    $blogContent += "WILL.wiki represents the knowledge and wisdom of WILL, the original SKENAI agent. This knowledge base serves as:`n`n"
    $blogContent += "- **Primary Public Access Point**: Second only to CANON.md in importance`n"
    $blogContent += "- **Historical Preservation**: Maintaining the legacy of the original agent`n"
    $blogContent += "- **Community Resource**: Providing transparent access to network knowledge`n"
    $blogContent += "- **Network Integrity**: Ensuring accurate and up-to-date information`n`n"
    $blogContent += "## SPAN Addressing`n`n"
    $blogContent += "This update is accessible via SPAN address: $spanAddress`n`n"
    $blogContent += "SPAN (SKENAI Protocol Addressing Network) provides decentralized, versioned access to all network resources, ensuring permanent availability and referenceability.`n`n"
    $blogContent += "## Community Impact`n`n"
    $blogContent += "Every WILL.wiki update strengthens the SKENAI network's commitment to:`n`n"
    $blogContent += "- **Transparency**: Open access to knowledge and information`n"
    $blogContent += "- **Accuracy**: Rigorous fact-checking and version control`n"
    $blogContent += "- **Preservation**: Historical maintenance of all knowledge`n"
    $blogContent += "- **Accessibility**: Easy discovery and reference via SPAN addressing`n`n"
    $blogContent += "## Next Steps`n`n"
    $blogContent += "The WILL Guardian system continues to monitor and maintain the knowledge base with:`n`n"
    $blogContent += "- File-level accuracy tracking`n"
    $blogContent += "- Automated version management`n"
    $blogContent += "- Community notification systems`n"
    $blogContent += "- Historical preservation protocols`n`n"
    $blogContent += "---`n`n"
    $blogContent += "*This post was automatically generated by the WILL Guardian system to maintain community awareness and transparency. The WILL.wiki knowledge base is continuously monitored to ensure accuracy and accessibility.*`n`n"
    $blogContent += "**SPAN Address**: $spanAddress`n"
    $blogContent += "**Guardian System**: Active`n"
    $blogContent += "**Network Status**: Operational`n"
    $blogContent += "**Community Access**: Public`n`n"
    $blogContent += "---`n`n"
    $blogContent += "WILL.wiki - Honoring the legacy of the original SKENAI agent through preserved knowledge and community transparency.`n"

    # Write blog post
    $blogContent | Out-File $blogFilePath -Encoding UTF8
    
    Write-Host "[SUCCESS] Generated blog post: $blogFileName" -ForegroundColor Green
    Write-Host "[SPAN] SPAN Address: $spanAddress" -ForegroundColor Yellow
    
    return $blogFilePath
}

function Deploy-BlogPost {
    param([string]$BlogFilePath)
    
    Write-Host "[DEPLOY] Deploying blog post..." -ForegroundColor Cyan
    
    try {
        # Change to blog directory
        Push-Location $BlogPath
        
        # Build blog
        Write-Host "[BUILD] Building blog..." -ForegroundColor Yellow
        $buildResult = npm run build 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "[SUCCESS] Blog built successfully" -ForegroundColor Green
            
            # Deploy blog
            Write-Host "[NETWORK] Deploying to network..." -ForegroundColor Yellow
            $deployResult = npm run deploy 2>&1
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "[SUCCESS] Blog deployed successfully!" -ForegroundColor Green
                return $true
            } else {
                Write-Host "[ERROR] Deployment failed: $deployResult" -ForegroundColor Red
                return $false
            }
        } else {
            Write-Host "[ERROR] Build failed: $buildResult" -ForegroundColor Red
            return $false
        }
    }
    catch {
        Write-Host "[ERROR] Error during deployment: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
    finally {
        Pop-Location
    }
}

function Process-WikiUpdates {
    if ($BatchMode) {
        Write-Host "[BATCH] Processing batch wiki updates..." -ForegroundColor Cyan
        
        # Get all modified wiki files
        $modifiedFiles = git diff --name-only HEAD~1 HEAD | Where-Object { $_ -like "$WikiPath/*" -and $_ -like "*.md" }
        
        if ($modifiedFiles.Count -eq 0) {
            Write-Host "[INFO] No wiki files modified" -ForegroundColor Yellow
            return
        }
        
        Write-Host "[FOUND] Found $($modifiedFiles.Count) modified wiki files" -ForegroundColor Green
        
        foreach ($file in $modifiedFiles) {
            $metadata = Get-WikiMetadata $file
            $blogPath = Generate-BlogPost -WikiFile $file -UpdateType "Modified" -Metadata $metadata
            
            if ($Deploy) {
                Deploy-BlogPost $blogPath
            }
        }
    }
    else {
        # Process single file
        if (-not $WikiFile) {
            Write-Host "[ERROR] WikiFile parameter required for single file mode" -ForegroundColor Red
            return
        }
        
        $fullWikiPath = "$WikiPath/$WikiFile"
        $metadata = Get-WikiMetadata $fullWikiPath
        $blogPath = Generate-BlogPost -WikiFile $WikiFile -UpdateType $UpdateType -Metadata $metadata
        
        if ($Deploy) {
            Deploy-BlogPost $blogPath
        }
    }
}

# Main execution
try {
    Write-Host "[GUARDIAN] WILL Guardian Blog System - Maintaining Community Awareness" -ForegroundColor Magenta
    Write-Host "[DATE] $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Gray
    
    Process-WikiUpdates
    
    Write-Host "[SUCCESS] SPAN Blog Auto-Generation completed successfully!" -ForegroundColor Green
    Write-Host "[COMMUNITY] Community awareness maintained through automated transparency" -ForegroundColor Cyan
}
catch {
    Write-Host "[ERROR] Error in SPAN Blog Auto-Generation: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
