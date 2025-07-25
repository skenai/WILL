# Version badge templates
$v2Badge = @"
[![WILL Version](https://img.shields.io/badge/WILL-v2.0.0-blue.svg)](https://github.com/shibakery/WILL/tree/v2.0.0)
[![Documentation](https://img.shields.io/badge/docs-current-green.svg)](https://github.com/shibakery/WILL/wiki)

> **Version Notice**: This documentation is for WILL v2.0.0. For older versions:
> - [v1.0.0 Documentation](https://github.com/shibakery/WILL/tree/v1.0.0/versions/v1.0.0)

"@

$v1Badge = @"
[![WILL Version](https://img.shields.io/badge/WILL-v1.0.0-blue.svg)](https://github.com/shibakery/WILL/tree/v1.0.0)
[![Documentation](https://img.shields.io/badge/docs-archive-yellow.svg)](https://github.com/shibakery/WILL/tree/v1.0.0/versions/v1.0.0)

> **Version Notice**: This is archived documentation for WILL v1.0.0. 
> For the latest version, see [current documentation](https://github.com/shibakery/WILL/wiki).

"@

# Get all markdown files
$v2Files = Get-ChildItem -Path "versions\v2.0.0" -Filter "*.md" -Recurse
$v1Files = Get-ChildItem -Path "versions\v1.0.0" -Filter "*.md" -Recurse

# Function to add badge to file
function Add-VersionBadge($file, $badge) {
    $content = Get-Content $file.FullName -Raw
    if ($content -notmatch "!\[WILL Version\]") {
        $titleMatch = $content -match "^#\s+(.+)$"
        if ($titleMatch) {
            $newContent = $content -replace "^#\s+(.+)$", "#`$1`n`n$badge"
            Set-Content -Path $file.FullName -Value $newContent
            Write-Host "Added badge to $($file.Name)"
        }
    }
}

# Add badges to v2.0.0 files
foreach ($file in $v2Files) {
    Add-VersionBadge $file $v2Badge
}

# Add badges to v1.0.0 files
foreach ($file in $v1Files) {
    Add-VersionBadge $file $v1Badge
}

Write-Host "Version badges added to all documentation files"
