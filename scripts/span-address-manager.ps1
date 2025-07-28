#!/usr/bin/env powershell
<#
.SYNOPSIS
SPAN Address Manager for WILL.wiki Integration

.DESCRIPTION
Manages SPAN addressing for all WILL.wiki entries
- Generates unique SPAN addresses
- Maintains address registry
- Integrates with network routing
- Ensures accessibility across SKENAI network

.EXAMPLE
.\span-address-manager.ps1 -GenerateAll
.\span-address-manager.ps1 -UpdateRegistry
#>

param(
    [switch]$GenerateAll,
    [switch]$UpdateRegistry,
    [switch]$ValidateAddresses,
    [string]$SpecificFile
)

# SPAN Configuration - Matching SKENAI Registry System
$SpanRegistry = "registries/span_addresses.json"
$WikiPath = "WILL.wiki"
$SpanNetwork = "skenai"
$SpanEntityType = "wiki"
$SpanEntityId = "will"

Write-Host "🌐 SPAN Address Manager for WILL.wiki" -ForegroundColor Cyan

function Initialize-SpanRegistry {
    # Ensure registries directory exists
    $registriesDir = Split-Path $SpanRegistry
    if (-not (Test-Path $registriesDir)) {
        New-Item -ItemType Directory -Path $registriesDir -Force | Out-Null
    }
    
    if (-not (Test-Path $SpanRegistry)) {
        # Initialize as array to match existing SKENAI registry format
        $initialRegistry = @()
        
        $initialRegistry | ConvertTo-Json -Depth 10 | Out-File $SpanRegistry -Encoding UTF8
        Write-Host "📋 Initialized SPAN registry (SKENAI format)" -ForegroundColor Green
    }
}

function Get-SpanRegistry {
    if (Test-Path $SpanRegistry) {
        return Get-Content $SpanRegistry -Raw | ConvertFrom-Json
    }
    return $null
}

function Save-SpanRegistry {
    param([object]$Registry)
    
    $Registry.last_updated = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $Registry | ConvertTo-Json -Depth 10 | Out-File $SpanRegistry -Encoding UTF8
}

function Generate-SpanAddress {
    param(
        [string]$FilePath,
        [object]$FileMetadata
    )
    
    # Create resource path from file structure
    $relativePath = $FilePath.Replace($WikiPath, "").Replace("\", "/").TrimStart("/")
    $pathParts = $relativePath -split "/"
    
    # Build resource path
    $resourcePath = ""
    
    # Handle versioned directories
    if ($pathParts[0] -eq "versions") {
        $resourcePath += "v/$($pathParts[1])/"
        $pathParts = $pathParts[2..($pathParts.Length-1)]
    }
    
    # Add category/type if exists
    if ($pathParts.Length -gt 1) {
        $resourcePath += "$($pathParts[0])/"
    }
    
    # Add file identifier (without .md extension)
    $fileName = $pathParts[-1] -replace '\.md$', ''
    $resourcePath += $fileName
    
    # Build proper SPAN address: span://network/entity_type/entity_id/resource_path
    $spanAddress = "span://$SpanNetwork/$SpanEntityType/$SpanEntityId/$resourcePath"
    
    # Add version parameter if available
    if ($FileMetadata.version) {
        $spanAddress += "?v=$($FileMetadata.version)"
    }
    
    return $spanAddress
}

function Register-SpanAddress {
    param(
        [string]$FilePath,
        [string]$SpanAddress,
        [object]$FileMetadata
    )
    
    $registry = Get-SpanRegistry
    
    $addressEntry = @{
        file_path = $FilePath
        span_address = $SpanAddress
        version = $FileMetadata.version ?? "1.0.0"
        type = $FileMetadata.type ?? "document"
        status = $FileMetadata.status ?? "active"
        tags = $FileMetadata.tags ?? @()
        created = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        last_verified = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        access_count = 0
        priority = if ($FileMetadata.type -eq "core") { "high" } else { "normal" }
    }
    
    $registry.addresses[$SpanAddress] = $addressEntry
    $registry.statistics.total_addresses = $registry.addresses.Count
    
    Save-SpanRegistry $registry
    
    Write-Host "📍 Registered: $SpanAddress" -ForegroundColor Green
    return $addressEntry
}

function Update-FileWithSpanAddress {
    param(
        [string]$FilePath,
        [string]$SpanAddress
    )
    
    $content = Get-Content $FilePath -Raw
    
    # Check if SPAN address already exists in frontmatter
    if ($content -match 'span_address:\s*(.+)') {
        $existingAddress = $matches[1].Trim('"')
        if ($existingAddress -ne $SpanAddress) {
            $content = $content -replace "span_address:\s*.+", "span_address: `"$SpanAddress`""
            Write-Host "🔄 Updated SPAN address in $FilePath" -ForegroundColor Yellow
        }
    } else {
        # Add SPAN address to frontmatter
        if ($content -match '^(---\r?\n.*?\r?\n)---') {
            $frontmatter = $matches[1]
            $newFrontmatter = $frontmatter + "span_address: `"$SpanAddress`"`n"
            $content = $content -replace '^---\r?\n.*?\r?\n---', "---`n$newFrontmatter---"
            Write-Host "➕ Added SPAN address to $FilePath" -ForegroundColor Cyan
        }
    }
    
    $content | Out-File $FilePath -Encoding UTF8 -NoNewline
}

function Validate-SpanAddresses {
    $registry = Get-SpanRegistry
    $validAddresses = 0
    $invalidAddresses = 0
    
    Write-Host "`n🔍 Validating SPAN addresses..." -ForegroundColor Cyan
    
    foreach ($address in $registry.addresses.Keys) {
        $entry = $registry.addresses[$address]
        
        if (Test-Path $entry.file_path) {
            $validAddresses++
            Write-Host "✅ $address" -ForegroundColor Green
        } else {
            $invalidAddresses++
            Write-Host "❌ $address (file not found: $($entry.file_path))" -ForegroundColor Red
        }
    }
    
    Write-Host "`n📊 Validation Results:" -ForegroundColor Yellow
    Write-Host "   Valid addresses: $validAddresses" -ForegroundColor Green
    Write-Host "   Invalid addresses: $invalidAddresses" -ForegroundColor Red
    Write-Host "   Success rate: $([math]::Round(($validAddresses / ($validAddresses + $invalidAddresses)) * 100, 2))%" -ForegroundColor Cyan
}

function Generate-SpanRouteMap {
    $registry = Get-SpanRegistry
    
    $routeMap = @{
        version = "1.0.0"
        generated = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        base_url = $SpanBase
        routes = @{}
    }
    
    foreach ($address in $registry.addresses.Keys) {
        $entry = $registry.addresses[$address]
        $route = $address -replace "^$([regex]::Escape($SpanBase))", ""
        
        $routeMap.routes[$route] = @{
            file = $entry.file_path
            type = $entry.type
            status = $entry.status
            version = $entry.version
            priority = $entry.priority
        }
    }
    
    $routeMap | ConvertTo-Json -Depth 10 | Out-File "span-route-map.json" -Encoding UTF8
    Write-Host "🗺️  Generated SPAN route map" -ForegroundColor Green
}

# Main execution
Initialize-SpanRegistry

if ($GenerateAll) {
    Write-Host "`n🌐 Generating SPAN addresses for all WILL.wiki files..." -ForegroundColor Cyan
    
    $allFiles = Get-ChildItem $WikiPath -Recurse -Filter "*.md"
    $processedCount = 0
    
    foreach ($file in $allFiles) {
        # Get file metadata
        $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
        $metadata = @{}
        
        if ($content -match '^---\r?\n(.*?)\r?\n---') {
            $yamlContent = $matches[1]
            $yamlContent -split '\r?\n' | ForEach-Object {
                if ($_ -match '^(\w+):\s*(.+)$') {
                    $metadata[$matches[1]] = $matches[2].Trim('"[]')
                }
            }
        }
        
        # Generate SPAN address
        $spanAddress = Generate-SpanAddress $file.FullName $metadata
        
        # Register address
        Register-SpanAddress $file.FullName $spanAddress $metadata
        
        # Update file with SPAN address
        Update-FileWithSpanAddress $file.FullName $spanAddress
        
        $processedCount++
    }
    
    Write-Host "`n✅ Processed $processedCount files" -ForegroundColor Green
    Generate-SpanRouteMap
}

if ($UpdateRegistry) {
    Write-Host "`n🔄 Updating SPAN registry..." -ForegroundColor Cyan
    $registry = Get-SpanRegistry
    
    # Update statistics
    $activeCount = 0
    $deprecatedCount = 0
    
    foreach ($address in $registry.addresses.Keys) {
        $entry = $registry.addresses[$address]
        if ($entry.status -eq "active") {
            $activeCount++
        } elseif ($entry.status -eq "deprecated") {
            $deprecatedCount++
        }
    }
    
    $registry.statistics.active_addresses = $activeCount
    $registry.statistics.deprecated_addresses = $deprecatedCount
    
    Save-SpanRegistry $registry
    Write-Host "✅ Registry updated" -ForegroundColor Green
}

if ($ValidateAddresses) {
    Validate-SpanAddresses
}

if ($SpecificFile) {
    Write-Host "`n🎯 Processing specific file: $SpecificFile" -ForegroundColor Cyan
    
    if (Test-Path $SpecificFile) {
        # Process single file
        $content = Get-Content $SpecificFile -Raw
        $metadata = @{}
        
        if ($content -match '^---\r?\n(.*?)\r?\n---') {
            $yamlContent = $matches[1]
            $yamlContent -split '\r?\n' | ForEach-Object {
                if ($_ -match '^(\w+):\s*(.+)$') {
                    $metadata[$matches[1]] = $matches[2].Trim('"[]')
                }
            }
        }
        
        $spanAddress = Generate-SpanAddress $SpecificFile $metadata
        Register-SpanAddress $SpecificFile $spanAddress $metadata
        Update-FileWithSpanAddress $SpecificFile $spanAddress
        
        Write-Host "✅ Processed: $spanAddress" -ForegroundColor Green
    } else {
        Write-Host "❌ File not found: $SpecificFile" -ForegroundColor Red
    }
}

Write-Host "`n🌐 SPAN Address Manager complete" -ForegroundColor Green
Write-Host "📍 All WILL.wiki entries now have network addresses" -ForegroundColor Yellow
