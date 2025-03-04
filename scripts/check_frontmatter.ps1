# Simple frontmatter validation without external dependencies
param(
    [Parameter(Mandatory=$true)]
    [string]$Directory
)

$validTypes = @(
    'system-doc',
    'framework-doc',
    'architecture-doc',
    'api-doc',
    'guide-doc',
    'template-doc'
)

$validStatuses = @(
    'public',
    'internal',
    'draft',
    'archived'
)

function Test-Frontmatter {
    param(
        [string]$FilePath
    )

    $issues = @()
    $content = Get-Content $FilePath -Raw
    
    # Check if file has frontmatter
    if (-not ($content -match "(?s)^---[\r\n]+(.*?)[\r\n]+---")) {
        return @("Missing frontmatter section")
    }

    $frontmatter = $matches[1]
    
    # Required fields
    if (-not ($frontmatter -match "version:\s*(\d+\.\d+\.\d+)")) {
        $issues += "Missing or invalid version (should be X.Y.Z)"
    }
    
    if (-not ($frontmatter -match "date:\s*(\d{4}-\d{2}-\d{2})")) {
        $issues += "Missing or invalid date (should be YYYY-MM-DD)"
    }
    
    if (-not ($frontmatter -match "type:\s*(\w+-doc)")) {
        $issues += "Missing type"
    }
    elseif ($matches[1] -notin $validTypes) {
        $issues += "Invalid type: $($matches[1])"
    }
    
    if (-not ($frontmatter -match "status:\s*(\w+)")) {
        $issues += "Missing status"
    }
    elseif ($matches[1] -notin $validStatuses) {
        $issues += "Invalid status: $($matches[1])"
    }
    
    # Check for required sections
    if (-not ($frontmatter -match "tags:")) { $issues += "Missing tags section" }
    if (-not ($frontmatter -match "related:")) { $issues += "Missing related section" }
    if (-not ($frontmatter -match "changelog:")) { $issues += "Missing changelog section" }
    
    return $issues
}

# Get all markdown files
$files = Get-ChildItem -Path $Directory -Filter "*.md" -Recurse -Exclude "versions/*"

$hasIssues = $false
foreach ($file in $files) {
    $fileIssues = Test-Frontmatter -FilePath $file.FullName
    if ($fileIssues.Count -gt 0) {
        Write-Host "`nIssues in $($file.Name):" -ForegroundColor Red
        foreach ($issue in $fileIssues) {
            Write-Host "  - $issue" -ForegroundColor Yellow
        }
        $hasIssues = $true
    }
}

if (-not $hasIssues) {
    Write-Host "`nAll files passed frontmatter validation!" -ForegroundColor Green
}
else {
    Write-Host "`nSome files have frontmatter issues. Please fix them." -ForegroundColor Red
    exit 1
}
