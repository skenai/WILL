# Documentation update script
$v2Badge = @"
[![WILL Version](https://img.shields.io/badge/WILL-v2.0.0-blue.svg)](https://github.com/shibakery/WILL/tree/v2.0.0)
[![Documentation](https://img.shields.io/badge/docs-current-green.svg)](https://github.com/shibakery/WILL/wiki)

"@

$v1Badge = @"
[![WILL Version](https://img.shields.io/badge/WILL-v1.0.0-blue.svg)](https://github.com/shibakery/WILL/tree/v1.0.0)
[![Documentation](https://img.shields.io/badge/docs-archive-yellow.svg)](https://github.com/shibakery/WILL/tree/v1.0.0/versions/v1.0.0)

"@

# Files to skip
$skipFiles = @(
    "VERSION-BADGE-TEMPLATE.md",
    "VERSION-HISTORY.md",
    "RELEASE-1.0.0.md",
    "RELEASE-2.0.0.md",
    "MIGRATION-1.0.0-to-2.0.0.md",
    "README.md"
)

# Key v2.0.0 components to add
$v2Components = @{
    "NATURAL Framework" = @"
## Integration with NATURAL Framework
- Clean repository separation
- Natural pipeline flow
- Validator protection
- Interface standards
"@

    "Three-Graph Lattice" = @"
## Integration with Three-Graph Lattice
- Technical graph validation
- Economic resource optimization
- Quality metrics tracking
"@

    "Pipeline API" = @"
## Pipeline API Integration
- /pipeline/submit - Entry point
- /pipeline/validate - Basic checks
- /pipeline/analyze - Efficiency (Q.1)
- /pipeline/patterns - Recognition (Q.2)
- /pipeline/status - State checks
- /pipeline/vote - Governance
"@
}

function Add-VersionBadge($file, $badge) {
    $content = Get-Content $file.FullName -Raw
    if ($content -notmatch "!\[WILL Version\]") {
        $titleMatch = $content -match "^#\s+(.+)$"
        if ($titleMatch) {
            $newContent = $content -replace "^#\s+(.+)$", "#`$1`n`n$badge"
            Set-Content -Path $file.FullName -Value $newContent -NoNewline
            Write-Host "Added badge to $($file.Name)"
        }
    }
}

function Add-V2Components($file) {
    $content = Get-Content $file.FullName -Raw
    $modified = $false

    foreach ($component in $v2Components.Keys) {
        if ($content -notmatch [regex]::Escape($component)) {
            $content += "`n`n$($v2Components[$component])"
            $modified = $true
        }
    }

    if ($modified) {
        Set-Content -Path $file.FullName -Value $content -NoNewline
        Write-Host "Added v2.0.0 components to $($file.Name)"
    }
}

# Get all markdown files
Write-Host "`nUpdating documentation files...`n"

# Update v2.0.0 files
Get-ChildItem -Path "." -Filter "*.md" -Recurse | 
    Where-Object { 
        $skip = $false
        foreach ($skipPath in $skipFiles) {
            if ($_.Name -eq $skipPath -or $_.FullName -like "*v1.0.0*") {
                $skip = $true
                break
            }
        }
        -not $skip
    } | ForEach-Object {
        Add-VersionBadge $_ $v2Badge
        Add-V2Components $_
    }

# Update v1.0.0 files
Get-ChildItem -Path "versions\v1.0.0" -Filter "*.md" -Recurse | 
    Where-Object { 
        $skip = $false
        foreach ($skipPath in $skipFiles) {
            if ($_.Name -eq $skipPath) {
                $skip = $true
                break
            }
        }
        -not $skip
    } | ForEach-Object {
        Add-VersionBadge $_ $v1Badge
    }

Write-Host "`nDocumentation update complete!"

# Create systematic update plan
$updatePlan = @"
# Documentation Update Plan

## High Priority
1. API Documentation
   - API-Reference.md
   - API-Documentation.md
   - API.md

2. Core Components
   - LEGEND-System.md
   - System-Architecture.md
   - WILL-System.md

3. Framework Documentation
   - NATURAL-Framework.md
   - Three-Graph-Lattice.md
   - QUANTUM-Framework.md
   - Validation-Framework.md

## Medium Priority
1. Integration Guides
   - Integration-Guide.md
   - GitHub-Integration.md
   - Social-Integration.md

2. Security Documentation
   - Security-Protocols.md
   - Security-and-Testing.md

3. Development Guides
   - Best-Practices.md
   - Contributing.md
   - QuickStart.md

## Low Priority
1. Supporting Documentation
   - FAQ.md
   - Community-Guidelines.md
   - Support.md

2. Additional Components
   - Token-System.md
   - Training-System.md
   - Pattern-Recognition.md

## Checklist
- [ ] Add version badges
- [ ] Update content for v2.0.0
- [ ] Add NATURAL Framework integration
- [ ] Add Three-Graph Lattice references
- [ ] Update API endpoints
- [ ] Add code examples
- [ ] Review security implications
- [ ] Test all links
"@

Set-Content -Path "UPDATE-PLAN.md" -Value $updatePlan
Write-Host "`nCreated UPDATE-PLAN.md with systematic update plan"
