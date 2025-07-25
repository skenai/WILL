# V1.0.0 Core Files
$v1_core = @(
    "Architecture.md",
    "System-Overview.md",
    "WILL-System.md",
    "LEGEND-System.md"
)

# V1.0.0 API Files
$v1_api = @(
    "API.md",
    "API-Documentation.md",
    "API-Reference.md"
)

# V1.0.0 Guides
$v1_guides = @(
    "Best-Practices.md",
    "Community-Guidelines.md",
    "Contributing.md",
    "QuickStart.md",
    "WILL-User-Guide.md"
)

# V2.0.0 Core Files
$v2_core = @(
    "Architecture.md",
    "System-Overview.md",
    "WILL-System.md",
    "LEGEND-System.md",
    "System-Architecture.md",
    "Three-Stage-Architecture.md"
)

# V2.0.0 API Files
$v2_api = @(
    "API.md",
    "API-Documentation.md",
    "API-Reference.md",
    "API-Integration.md"
)

# V2.0.0 Frameworks
$v2_frameworks = @(
    "NATURAL-Framework.md",
    "GFORCE-Framework.md",
    "QUANTUM-Framework.md",
    "Validation-Framework.md",
    "Three-Graph-Lattice.md"
)

# V2.0.0 Guides
$v2_guides = @(
    "Best-Practices.md",
    "Community-Guidelines.md",
    "Contributing.md",
    "QuickStart.md",
    "WILL-User-Guide.md",
    "WillChat-Component.md",
    "XP-Technical-Guide.md"
)

# Copy function
function Copy-Files($files, $targetDir) {
    foreach ($file in $files) {
        if (Test-Path $file) {
            Copy-Item $file $targetDir -Force
        }
    }
}

# Copy v1.0.0 files
Copy-Files $v1_core "versions\v1.0.0\core"
Copy-Files $v1_api "versions\v1.0.0\api"
Copy-Files $v1_guides "versions\v1.0.0\guides"

# Copy v2.0.0 files
Copy-Files $v2_core "versions\v2.0.0\core"
Copy-Files $v2_api "versions\v2.0.0\api"
Copy-Files $v2_frameworks "versions\v2.0.0\frameworks"
Copy-Files $v2_guides "versions\v2.0.0\guides"
