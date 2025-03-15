---
version: 2.0.0
date: 2025-03-04
type: system-doc
status: public
tags: [william, migration, 1.0.0, 2.0.0]
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
# Migrating from WILL v1.0.0 to v2.0.0

This guide helps you migrate your WILL implementation from v1.0.0 to v2.0.0.

## Breaking Changes

### 1. Pipeline API Changes
The Pipeline API now follows the MCP (Market Coordination Protocol) standard:

#### Old Endpoints (v1.0.0)
```
/submit
/check
/status
```

#### New Endpoints (v2.0.0)
```
/pipeline/submit    # Entry point for proposals
/pipeline/validate # Basic validation checks
/pipeline/analyze  # Efficiency check (Q.1)
/pipeline/patterns # Pattern recognition (Q.2)
/pipeline/status   # Check proposal state
/pipeline/vote     # Governance decisions
```

### 2. NATURAL Framework Integration
The NATURAL Framework is now required for all implementations:

1. Clean Repository Structure:
   - Public API interface (WILL)
   - Private core validators (SKENAI-R)
   - Pattern analysis (SKENAI-Q)

2. Pipeline Flow:
   ```
   SKENAI > R-proposal > Q.1 > Q.2 > vote > R-final
   ```

### 3. Security Model Updates
- R validators are now final authority
- Vote gate required for major changes
- Core validators remain private
- Pattern emergence preserved

## New Features

### 1. Three-Graph Lattice
- Technical Graph (LEGEND)
- Economic Graph
- Quality Graph
- Cross-graph communication

### 2. WillChat Component
- Natural language interface
- Pattern-based responses
- Integration with existing systems

### 3. XP System
- Experience tracking
- Validator reputation
- Quality metrics

## Migration Steps

1. Update API Endpoints:
   - Replace old endpoints with new MCP-compliant ones
   - Update request/response formats
   - Implement new validation checks

2. Implement NATURAL Framework:
   ```
   your-implementation/
   ÃƒÂ¢Ã¢â‚¬ÂÃ…â€œÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ public/         # WILL interface
   ÃƒÂ¢Ã¢â‚¬ÂÃ…â€œÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ private/        # Core validators
   ÃƒÂ¢Ã¢â‚¬ÂÃ¢â‚¬ÂÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ÃƒÂ¢Ã¢â‚¬ÂÃ¢â€šÂ¬ quality/        # Pattern analysis
   ```

3. Security Updates:
   - Add vote gates for major changes
   - Implement R validator authority
   - Update security policies

4. Enable New Features:
   - Configure Three-Graph Lattice
   - Set up WillChat (optional)
   - Initialize XP system

## Verification Checklist

- [ ] All API endpoints updated to v2.0.0 format
- [ ] NATURAL Framework structure implemented
- [ ] Security model aligned with new requirements
- [ ] Three-Graph Lattice configured
- [ ] Documentation updated
- [ ] Tests passing with new changes

## Need Help?

- [v2.0.0 Documentation](https://github.com/shibakery/WILL/tree/v2.0.0)
- [Technical Support](https://github.com/shibakery/WILL/issues)
- [Community Forum](https://github.com/shibakery/WILL/discussions)
