# Required: Install-Module powershell-yaml
# Run with: ./validate_yaml_frontmatter.ps1 -Directory path/to/wiki

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

function Test-YamlFrontmatter {
    param(
        [string]$FilePath
    )

    $errors = @()
    $content = Get-Content $FilePath -Raw
    
    # Check if file has YAML frontmatter
    if (-not ($content -match "^---\s*\r?\n(.*?)\r?\n---\s*\r?\n")) {
        return @("Missing YAML frontmatter")
    }

    $yaml = $matches[1]
    try {
        $metadata = ConvertFrom-Yaml $yaml
    }
    catch {
        return @("Invalid YAML syntax")
    }

    # Required fields
    if (-not $metadata.version) { $errors += "Missing version" }
    elseif ($metadata.version -notmatch '^\d+\.\d+\.\d+$') { 
        $errors += "Invalid version format (should be X.Y.Z)" 
    }

    if (-not $metadata.date) { $errors += "Missing date" }
    elseif ($metadata.date -notmatch '^\d{4}-\d{2}-\d{2}$') {
        $errors += "Invalid date format (should be YYYY-MM-DD)"
    }

    if (-not $metadata.type) { $errors += "Missing type" }
    elseif ($metadata.type -notin $validTypes) {
        $errors += "Invalid type: $($metadata.type)"
    }

    if (-not $metadata.status) { $errors += "Missing status" }
    elseif ($metadata.status -notin $validStatuses) {
        $errors += "Invalid status: $($metadata.status)"
    }

    # Optional fields validation
    if ($metadata.tags -and -not ($metadata.tags -is [array])) {
        $errors += "Tags must be an array"
    }

    if ($metadata.related -and -not ($metadata.related -is [array])) {
        $errors += "Related must be an array"
    }

    # Changelog validation
    if (-not $metadata.changelog) { $errors += "Missing changelog" }
    elseif (-not ($metadata.changelog -is [array])) {
        $errors += "Changelog must be an array"
    }
    else {
        foreach ($entry in $metadata.changelog) {
            if (-not $entry.version) { $errors += "Changelog entry missing version" }
            if (-not $entry.date) { $errors += "Changelog entry missing date" }
            if (-not $entry.changes -or -not ($entry.changes -is [array])) {
                $errors += "Changelog entry must have changes array"
            }
        }
    }

    return $errors
}

# Get all markdown files
$files = Get-ChildItem -Path $Directory -Filter "*.md" -Recurse -Exclude "versions/*"

$hasErrors = $false
foreach ($file in $files) {
    $errors = Test-YamlFrontmatter -FilePath $file.FullName
    if ($errors.Count -gt 0) {
        Write-Host "`nErrors in $($file.Name):" -ForegroundColor Red
        foreach ($error in $errors) {
            Write-Host "  - $error" -ForegroundColor Yellow
        }
        $hasErrors = $true
    }
}

if (-not $hasErrors) {
    Write-Host "`nAll files passed YAML frontmatter validation!" -ForegroundColor Green
}
else {
    Write-Host "`nSome files have YAML frontmatter issues. Please fix them." -ForegroundColor Red
    exit 1
}
