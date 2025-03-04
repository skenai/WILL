---
version: 2.0.0
date: 2025-03-04
type: api-doc
status: public
tags: [william, api, documentation]
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
---
version: 2.0.0
date: 2025-03-04
type: api-doc
status: public
tags: [william, api, documentation]
related:
  - WILL-System.md
  - Three-Stage-Architecture.md
  - API-Reference.md
changelog:
  - version: 2.0.0
    date: 2025-03-04
    changes:
      - "MAJOR: Three-stage API integration"
      - "MAJOR: Enhanced endpoint system"
      - "MAJOR: Stage-specific API flows"
      - "MAJOR: Improved documentation framework"
    references:
      - "WILL-System"
  - version: 1.0.0
    date: 2025-03-03
    changes:
      - "MAJOR: Basic API framework"
      - "MAJOR: Initial endpoint system"
    references:
      - "GFORCE-Framework"
---

# WILL API Documentation

The WILL API follows the Market Coordination Protocol (MCP) standard for consistent and secure interactions.

## Overview

The API Documentation details WILLIAM's endpoints and integration points through a three-stage architecture.

## Core Components

### 1. Stage 1 (SKENAI)
```
[Raw] → [Initial] → [Basic]
  ↑        ↕          ↓
[Log] ← [Process] ← [Check]
```
- /api/v2/skenai/submit
- /api/v2/skenai/validate
- /api/v2/skenai/status
- /api/v2/skenai/check
- /api/v2/skenai/log

### 2. Stage 2 (SKENAI-Q)
```
[Deep] → [Quality] → [Validate]
  ↑         ↕           ↓
[Track] ← [Assess] ← [Review]
```
- /api/v2/quality/analyze
- /api/v2/quality/validate
- /api/v2/quality/review
- /api/v2/quality/assess
- /api/v2/quality/track

### 3. Stage 3 (SKENAI-R)
```
[Final] → [Deploy] → [Release]
  ↑         ↕          ↓
[Monitor] ← [Secure] ← [Track]
```
- /api/v2/release/verify
- /api/v2/release/deploy
- /api/v2/release/monitor
- /api/v2/release/secure
- /api/v2/release/track

## Security

All endpoints require:
- API Key authentication
- HTTPS encryption
- Rate limiting
- Request signing

## Response Formats

All responses follow:
```json
{
  "status": "success|error",
  "data": {},
  "error": null
}
```

## Version Support
- Current: v2.0.0
- Legacy: v1.0.0 (deprecated)
- [Migration Guide](versions/MIGRATION-1.0.0-to-2.0.0)

## Related Pages
- [[Integration-Guide]]
- [[Architecture]]
- [[FAQ]]

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

## Integration with Three-Graph Lattice
- Technical graph validation
- Economic resource optimization
- Quality metrics tracking