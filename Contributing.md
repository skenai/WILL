---
version: 2.0.0
date: 2025-03-04
type: system-doc
status: public
tags: [william, contributing]
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
# Contributing to WILL Documentation

## Wiki Structure

The WILL documentation is organized using a linked repository structure:

```
SKENAI/
ÃƒÂ¢Ã¢â‚¬ÂÃ…â€œÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ WILL/
ÃƒÂ¢Ã¢â‚¬ÂÃ¢â‚¬Å¡   ÃƒÂ¢Ã¢â‚¬ÂÃ…â€œÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ wiki/               # Primary documentation location
ÃƒÂ¢Ã¢â‚¬ÂÃ¢â‚¬Å¡   ÃƒÂ¢Ã¢â‚¬ÂÃ¢â‚¬Å¡   ÃƒÂ¢Ã¢â‚¬ÂÃ…â€œÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ *.md files     # Wiki content
ÃƒÂ¢Ã¢â‚¬ÂÃ¢â‚¬Å¡   ÃƒÂ¢Ã¢â‚¬ÂÃ¢â‚¬Å¡   ÃƒÂ¢Ã¢â‚¬ÂÃ¢â‚¬ÂÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ _Sidebar.md    # Navigation
ÃƒÂ¢Ã¢â‚¬ÂÃ¢â‚¬Å¡   ÃƒÂ¢Ã¢â‚¬ÂÃ…â€œÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ docs/              # Technical documentation
ÃƒÂ¢Ã¢â‚¬ÂÃ¢â‚¬Å¡   ÃƒÂ¢Ã¢â‚¬ÂÃ¢â‚¬ÂÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ scripts/           # Utility scripts
ÃƒÂ¢Ã¢â‚¬ÂÃ¢â‚¬Å¡       ÃƒÂ¢Ã¢â‚¬ÂÃ¢â‚¬ÂÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ update-wiki.bat # Wiki update automation
ÃƒÂ¢Ã¢â‚¬ÂÃ¢â‚¬ÂÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ WILL.wiki/             # GitHub Wiki (linked to WILL/wiki)
```

## How to Update Documentation

### Method 1: Using the Automation Script

1. Make your changes in the `WILL/wiki/` directory
2. Run the update script with a commit message:
   ```bash
   scripts/update-wiki.bat "your commit message here"
   ```

Example workflow:
```bash
# 1. Edit Research-and-XP.md to add new XP calculation examples
vim wiki/Research-and-XP.md

# 2. Update the documentation
scripts/update-wiki.bat "docs: add XP calculation examples for NFT minting"

# 3. Changes are automatically pushed to both repositories
```

### Method 2: Manual Update

1. Edit files in `WILL/wiki/`
2. Commit changes in WILL repository:
   ```bash
   git add wiki/
   git commit -m "docs: your changes"
   git push origin gh-pages
   ```
3. Changes will automatically appear in `WILL.wiki/`
4. Push wiki updates:
   ```bash
   cd ../WILL.wiki
   git add .
   git commit -m "docs: your changes"
   git push origin master
   ```

## Documentation Guidelines

1. **File Organization**
   - Keep all wiki content in `WILL/wiki/`
   - Use descriptive filenames with `-` separators
   - Include related files in appropriate sections

   Example:
   ```
   # Good filenames
   Research-and-XP.md
   EVS-Token-Integration.md
   Community-Guidelines.md

   # Bad filenames
   research.md
   evs_token.md
   community_stuff.md
   ```

2. **Content Structure**
   - Start each file with a clear title
   - Use proper markdown headings
   - Include a table of contents for longer documents

   Example:
   ```markdown
   # WILL Training System

   ## Table of Contents
   - [Overview](#overview)
   - [Components](#components)
   - [Integration](#integration)

   ## Overview
   The WILL training system...

   ## Components
   1. Pattern Recognition
   2. Neural Networks
   3. Feedback Loops

   ## Integration
   To integrate with the training system...
   ```

3. **Links and References**
   - Use relative links when referencing other wiki pages
   - Include links to relevant proposals
   - Reference related documentation when appropriate

   Example:
   ```markdown
   # Good link format
   See the [XP System](Research-and-XP.md#xp-system) for details.
   Related: [EVERSTRIKE Integration](Everstrike-Partnership.md)

   # Bad link format
   See https://github.com/shibakenfinance/WILL/wiki/Research-and-XP
   Check governance/proposals/everstrike.md
   ```

4. **Code Examples**
   - Use fenced code blocks with language specifiers
   - Include comments for complex code
   - Show both input and expected output

   Example:
   ```python
   # Calculate XP reward for proposal completion
   def calculate_xp(base_xp: int, track_multiplier: float, quality_score: int) -> int:
       """
       Calculate total XP reward for a proposal.
       
       Args:
           base_xp: Base XP amount (e.g., 2000 for Genesis)
           track_multiplier: Track-specific multiplier (e.g., 1.5 for Research)
           quality_score: Quality assessment score (0-1000)
           
       Returns:
           Total XP reward
       """
       return int(base_xp * track_multiplier * (1 + quality_score/1000))

   # Example usage
   xp = calculate_xp(2000, 1.5, 800)  # Research track, high quality
   print(f"XP Reward: {xp}")  # Output: XP Reward: 4400
   ```

5. **Updates and Maintenance**
   - Keep content up to date with latest changes
   - Review and update documentation regularly
   - Remove outdated information promptly

   Example changelog entry:
   ```markdown
   ## Changelog

   ### 2025-01-15
   - Added XP calculation examples
   - Updated token distribution formulas
   - Removed deprecated staking mechanics

   ### 2025-01-14
   - Added EVS token integration details
   - Fixed broken links in Training System
   ```

## Common Tasks

### 1. Adding a New Feature
```markdown
# Feature Name

## Overview
Brief description of the feature

## Technical Details
Implementation specifics

## Usage Examples
Code or configuration examples

## Integration Points
How it connects with other components
```

### 2. Updating API Documentation
```markdown
# API Endpoint

## Request
\```json
{
    "method": "POST",
    "path": "/api/v1/calculate-xp",
    "body": {
        "proposalId": "G-L1-021",
        "trackMultiplier": 1.5,
        "qualityScore": 800
    }
}
\```

## Response
\```json
{
    "status": "success",
    "data": {
        "xpReward": 4400,
        "breakdown": {
            "base": 2000,
            "trackBonus": 1000,
            "qualityBonus": 1400
        }
    }
}
\```
```

### 3. Adding System Architecture
```markdown
# System Component

## Architecture Diagram
\```mermaid
graph TD
    A[Client] --> B[API Gateway]
    B --> C[XP Calculator]
    C --> D[Token Distribution]
    D --> E[Governance]
\```

## Component Details
- **API Gateway**: Entry point for requests
- **XP Calculator**: Processes rewards
- **Token Distribution**: Handles token minting
- **Governance**: Manages proposal flow
```

## Technical Details

The wiki uses a junction point to link `WILL/wiki/` to `WILL.wiki/`. This means:
- Changes in `WILL/wiki/` automatically appear in `WILL.wiki/`
- Both repositories maintain their own git history
- Documentation is version-controlled alongside code

Example of checking wiki sync status:
```bash
# Check WILL repository status
cd WILL
git status

# Check wiki repository status
cd ../WILL.wiki
git status

# Verify junction point
dir WILL.wiki
```

## Need Help?

If you encounter any issues or need assistance:
1. Check the existing documentation
2. Review the [Contributing Guidelines](Contributing.md)
3. Open an issue in the WILL repository
4. Contact the development team

Example issue format:
```markdown
Title: [Documentation] Unclear XP calculation formula

Description:
- **Page**: Research-and-XP.md
- **Section**: Token Conversion
- **Problem**: Formula for calculating quality multiplier is ambiguous
- **Expected**: Clear explanation with step-by-step example
- **Additional Context**: [Screenshot or code snippet]


## Integration with NATURAL Framework
- Clean repository separation
- Natural pipeline flow
- Validator protection
- Interface standards

## Pipeline API Integration
- /pipeline/submit - Entry point
- /pipeline/validate - Basic checks
- /pipeline/analyze - Efficiency (Q.1)
- /pipeline/patterns - Recognition (Q.2)
- /pipeline/status - State checks
- /pipeline/vote - Governance