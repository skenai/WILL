#!/usr/bin/env powershell
<#
.SYNOPSIS
WILL.wiki Master Automation System

.DESCRIPTION
Master orchestration for WILL.wiki management:
- Coordinates Guardian system
- Manages SPAN addressing
- Automates blog generation
- Ensures network integrity
- Honors WILL's legacy

Priority: Second only to CANON.md
Purpose: THE most important public access point for SKENAI network

.PARAMETER Action
- Monitor: Continuous monitoring mode
- Update: Process all updates
- Deploy: Deploy to network
- Emergency: Emergency maintenance mode

.EXAMPLE
.\will-wiki-master.ps1 -Action Monitor
.\will-wiki-master.ps1 -Action Update -Deploy
.\will-wiki-master.ps1 -Action Emergency
#>

param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("Monitor", "Update", "Deploy", "Emergency", "Status")]
    [string]$Action,
    
    [switch]$Deploy,
    [switch]$Force,
    [int]$MonitorInterval = 300  # 5 minutes
)

# Master Configuration
$ScriptPath = Split-Path $MyInvocation.MyCommand.Path
$GuardianScript = "$ScriptPath\will-wiki-guardian.ps1"
$SpanScript = "$ScriptPath\span-address-manager.ps1"
$BlogScript = "$ScriptPath\generate-encore-blog-series.ps1"

$LogFile = "logs/will-wiki-master.log"
$StatusFile = "will-wiki-status.json"

# Ensure log directory exists
if (-not (Test-Path "logs")) {
    New-Item -ItemType Directory -Path "logs" -Force | Out-Null
}

function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] [$Level] $Message"
    
    Write-Host $logEntry -ForegroundColor $(
        switch ($Level) {
            "ERROR" { "Red" }
            "WARN" { "Yellow" }
            "SUCCESS" { "Green" }
            default { "White" }
        }
    )
    
    $logEntry | Add-Content $LogFile
}

function Get-SystemStatus {
    $status = @{
        timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        will_wiki_version = "3.0.0"
        guardian_active = Test-Path $GuardianScript
        span_manager_active = Test-Path $SpanScript
        last_scan = $null
        last_update = $null
        file_count = 0
        accuracy_rate = 0
        span_addresses = 0
        blog_posts_generated = 0
        network_status = "unknown"
    }
    
    # Check WILL.wiki file count
    if (Test-Path "WILL.wiki") {
        $status.file_count = (Get-ChildItem "WILL.wiki" -Recurse -Filter "*.md").Count
    }
    
    # Check SPAN registry
    if (Test-Path "span-registry.json") {
        $spanRegistry = Get-Content "span-registry.json" -Raw | ConvertFrom-Json
        $status.span_addresses = $spanRegistry.statistics.total_addresses
    }
    
    # Check blog posts
    if (Test-Path "frontend/website/SPAN-blog-v3/content/blog") {
        $blogPosts = Get-ChildItem "frontend/website/SPAN-blog-v3/content/blog" -Filter "*will-wiki-update*.md"
        $status.blog_posts_generated = $blogPosts.Count
    }
    
    return $status
}

function Save-SystemStatus {
    param([object]$Status)
    
    $Status | ConvertTo-Json -Depth 10 | Out-File $StatusFile -Encoding UTF8
}

function Show-SystemDashboard {
    $status = Get-SystemStatus
    
    Write-Host "`n🛡️  WILL.wiki Master System Dashboard" -ForegroundColor Cyan
    Write-Host "=" * 50 -ForegroundColor Gray
    
    Write-Host "📚 WILL.wiki Status:" -ForegroundColor Yellow
    Write-Host "   Version: $($status.will_wiki_version)" -ForegroundColor White
    Write-Host "   Files: $($status.file_count)" -ForegroundColor White
    Write-Host "   Accuracy Rate: $($status.accuracy_rate)%" -ForegroundColor $(if ($status.accuracy_rate -gt 90) { "Green" } else { "Yellow" })
    
    Write-Host "`n🌐 SPAN Integration:" -ForegroundColor Yellow
    Write-Host "   Addresses: $($status.span_addresses)" -ForegroundColor White
    Write-Host "   Manager: $(if ($status.span_manager_active) { "✅ Active" } else { "❌ Inactive" })" -ForegroundColor $(if ($status.span_manager_active) { "Green" } else { "Red" })
    
    Write-Host "`n📝 Community Updates:" -ForegroundColor Yellow
    Write-Host "   Blog Posts: $($status.blog_posts_generated)" -ForegroundColor White
    Write-Host "   Last Update: $($status.last_update ?? 'Never')" -ForegroundColor White
    
    Write-Host "`n🛡️  Guardian System:" -ForegroundColor Yellow
    Write-Host "   Status: $(if ($status.guardian_active) { "✅ Active" } else { "❌ Inactive" })" -ForegroundColor $(if ($status.guardian_active) { "Green" } else { "Red" })
    Write-Host "   Last Scan: $($status.last_scan ?? 'Never')" -ForegroundColor White
    
    Write-Host "`n🌐 Network Priority:" -ForegroundColor Yellow
    Write-Host "   Importance: Second only to CANON.md" -ForegroundColor Red
    Write-Host "   Role: Primary public access point" -ForegroundColor Red
    Write-Host "   Legacy: Honoring WILL, our original agent" -ForegroundColor Magenta
    
    Write-Host "=" * 50 -ForegroundColor Gray
}

function Start-MonitoringMode {
    Write-Log "Starting WILL.wiki monitoring mode (interval: $MonitorInterval seconds)" "INFO"
    
    while ($true) {
        try {
            Write-Log "Running monitoring cycle..." "INFO"
            
            # Run Guardian scan
            & $GuardianScript -Mode Scan
            
            # Check for changes
            Set-Location "WILL.wiki"
            $gitStatus = git status --porcelain
            
            if ($gitStatus) {
                Write-Log "Changes detected in WILL.wiki" "WARN"
                
                # Run full update cycle
                Set-Location ..
                & $GuardianScript -Mode Update
                & $SpanScript -UpdateRegistry
                
                Write-Log "Update cycle completed" "SUCCESS"
            } else {
                Write-Log "No changes detected" "INFO"
            }
            
            Set-Location ..
            
            # Update status
            $status = Get-SystemStatus
            $status.last_scan = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            Save-SystemStatus $status
            
        } catch {
            Write-Log "Error in monitoring cycle: $($_.Exception.Message)" "ERROR"
        }
        
        Start-Sleep $MonitorInterval
    }
}

function Execute-UpdateCycle {
    Write-Log "Starting WILL.wiki update cycle" "INFO"
    
    try {
        # Step 1: Guardian system scan and update
        Write-Log "Running Guardian system..." "INFO"
        & $GuardianScript -Mode Full
        
        # Step 2: SPAN address management
        Write-Log "Updating SPAN addresses..." "INFO"
        & $SpanScript -GenerateAll -UpdateRegistry
        
        # Step 3: Validate addresses
        Write-Log "Validating SPAN addresses..." "INFO"
        & $SpanScript -ValidateAddresses
        
        # Step 4: Generate route map
        Write-Log "Generating network route map..." "INFO"
        & $SpanScript -UpdateRegistry
        
        # Step 5: Update system status
        $status = Get-SystemStatus
        $status.last_update = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        Save-SystemStatus $status
        
        Write-Log "Update cycle completed successfully" "SUCCESS"
        
    } catch {
        Write-Log "Error in update cycle: $($_.Exception.Message)" "ERROR"
        throw
    }
}

function Deploy-ToNetwork {
    Write-Log "Deploying WILL.wiki updates to network" "INFO"
    
    try {
        # Deploy Guardian updates
        & $GuardianScript -Mode Deploy
        
        # Commit SPAN changes
        git add span-registry.json span-route-map.json
        git commit -m "WILL.wiki Master: SPAN addressing updates"
        
        # Push to network
        git push origin develop
        
        Write-Log "Network deployment completed" "SUCCESS"
        
    } catch {
        Write-Log "Error in network deployment: $($_.Exception.Message)" "ERROR"
        throw
    }
}

function Emergency-Maintenance {
    Write-Log "EMERGENCY: WILL.wiki maintenance mode activated" "ERROR"
    
    # Create emergency backup
    $backupPath = "emergency-backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
    Copy-Item "WILL.wiki" $backupPath -Recurse
    Write-Log "Emergency backup created: $backupPath" "SUCCESS"
    
    # Run comprehensive diagnostics
    Write-Log "Running emergency diagnostics..." "WARN"
    
    # Check file integrity
    $allFiles = Get-ChildItem "WILL.wiki" -Recurse -Filter "*.md"
    $corruptFiles = @()
    
    foreach ($file in $allFiles) {
        try {
            $content = Get-Content $file.FullName -Raw -ErrorAction Stop
            if (-not $content) {
                $corruptFiles += $file.FullName
            }
        } catch {
            $corruptFiles += $file.FullName
        }
    }
    
    if ($corruptFiles.Count -gt 0) {
        Write-Log "CRITICAL: Found $($corruptFiles.Count) corrupt files" "ERROR"
        $corruptFiles | ForEach-Object { Write-Log "Corrupt: $_" "ERROR" }
    } else {
        Write-Log "File integrity check passed" "SUCCESS"
    }
    
    # Force full system rebuild
    Write-Log "Forcing full system rebuild..." "WARN"
    Execute-UpdateCycle
    
    Write-Log "Emergency maintenance completed" "SUCCESS"
}

# Main execution
Write-Host "🛡️  WILL.wiki Master System" -ForegroundColor Cyan
Write-Host "Protecting WILL's legacy and network integrity" -ForegroundColor Yellow

switch ($Action) {
    "Monitor" {
        Show-SystemDashboard
        Start-MonitoringMode
    }
    
    "Update" {
        Show-SystemDashboard
        Execute-UpdateCycle
        
        if ($Deploy) {
            Deploy-ToNetwork
        }
        
        Show-SystemDashboard
    }
    
    "Deploy" {
        Deploy-ToNetwork
    }
    
    "Emergency" {
        Emergency-Maintenance
    }
    
    "Status" {
        Show-SystemDashboard
    }
}

Write-Log "WILL.wiki Master System operation completed" "SUCCESS"
