# Documentation check script
$results = @{
    missing_badges = @()
    outdated_content = @()
    needs_review = @()
}

# Key v2.0.0 terms to check for
$v2Terms = @(
    "NATURAL Framework",
    "Three-Graph Lattice",
    "WillChat",
    "XP System",
    "/pipeline/"
)

# Files to skip
$skipFiles = @(
    "versions/v1.0.0",
    "VERSION-BADGE-TEMPLATE.md",
    "VERSION-HISTORY.md",
    "RELEASE-1.0.0.md",
    "RELEASE-2.0.0.md",
    "MIGRATION-1.0.0-to-2.0.0.md"
)

# Get all markdown files
$files = Get-ChildItem -Path "." -Filter "*.md" -Recurse | 
    Where-Object { 
        $skip = $false
        foreach ($skipPath in $skipFiles) {
            if ($_.FullName -like "*$skipPath*") {
                $skip = $true
                break
            }
        }
        -not $skip
    }

Write-Host "`nChecking documentation files...`n"

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw
    $relativePath = $file.FullName.Replace($PWD.Path + "\", "")
    
    # Check for version badge
    if ($content -notmatch "!\[WILL Version\]") {
        $results.missing_badges += $relativePath
    }
    
    # Check for v2.0.0 terms
    $hasV2Content = $false
    foreach ($term in $v2Terms) {
        if ($content -match $term) {
            $hasV2Content = $true
            break
        }
    }
    
    if (-not $hasV2Content) {
        $results.needs_review += $relativePath
    }
    
    # Check for outdated content
    if ($content -match "v1\.0\.0" -and -not $content -match "v2\.0\.0") {
        $results.outdated_content += $relativePath
    }
}

# Print results
Write-Host "Documentation Check Results`n------------------------"

Write-Host "`nFiles missing version badges:"
if ($results.missing_badges.Count -eq 0) {
    Write-Host "None"
} else {
    $results.missing_badges | ForEach-Object { Write-Host "- $_" }
}

Write-Host "`nFiles with outdated content:"
if ($results.outdated_content.Count -eq 0) {
    Write-Host "None"
} else {
    $results.outdated_content | ForEach-Object { Write-Host "- $_" }
}

Write-Host "`nFiles needing v2.0.0 review:"
if ($results.needs_review.Count -eq 0) {
    Write-Host "None"
} else {
    $results.needs_review | ForEach-Object { Write-Host "- $_" }
}

# Save results to file
$timestamp = Get-Date -Format "yyyy-MM-dd-HH-mm"
$results | ConvertTo-Json | Set-Content "doc-check-$timestamp.json"

Write-Host "`nResults saved to doc-check-$timestamp.json"
