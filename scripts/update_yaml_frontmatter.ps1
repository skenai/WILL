param(
    [Parameter(Mandatory=$true)]
    [string]$FilePath
)

$content = Get-Content $FilePath -Raw
$filename = Split-Path $FilePath -Leaf
$basename = [System.IO.Path]::GetFileNameWithoutExtension($filename)

# Determine document type based on filename
$type = "system-doc" # default
if ($filename -match "^API-") { $type = "api-doc" }
elseif ($basename -match "Framework$") { $type = "framework-doc" }
elseif ($basename -match "^Integration-|Guide$") { $type = "guide-doc" }
elseif ($basename -match "Architecture$") { $type = "architecture-doc" }

# Create tags based on filename
$tags = @("william")
$words = $basename -split "-"
foreach ($word in $words) {
    if ($word -notmatch "^(and|the|for|to|of|in|on|at|by)$") {
        $tags += $word.ToLower()
    }
}

# Generate YAML frontmatter
$yaml = @"
---
version: 2.0.0
date: 2025-03-04
type: $type
status: public
tags: [$($tags -join ", ")]
related: []
changelog:
  - version: 2.0.0
    date: 2025-03-04
    changes:
      - "MAJOR: Switch to YAML frontmatter"
      - "MAJOR: Enhanced metadata structure"
    references: []
  - version: 1.0.0
    date: 2025-03-03
    changes:
      - "MAJOR: Initial documentation"
    references: []
---

"@

# Remove existing YAML frontmatter if present
if ($content -match "^---\s*\r?\n(.*?)\r?\n---\s*\r?\n"){ 
    $content = $content -replace "^---\s*\r?\n(.*?)\r?\n---\s*\r?\n", ""
}

# Remove version badges
$content = $content -replace "\[!\[WILL Version\]\(.*?\)\]\(.*?\)\s*\r?\n", ""
$content = $content -replace "\[!\[Documentation\]\(.*?\)\]\(.*?\)\s*\r?\n", ""

# Remove version notice blocks
$content = $content -replace "> \*\*Version Notice\*\*:.*?(?=\r?\n\r?\n|\z)", ""

# Add new YAML frontmatter
$newContent = $yaml + $content.TrimStart()

# Save the file
$newContent | Set-Content $FilePath -NoNewline
