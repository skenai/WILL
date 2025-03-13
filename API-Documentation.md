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
# WILL API Documentation

The WILL API follows the Market Coordination Protocol (MCP) standard for consistent and secure interactions.

## Overview

The API Documentation details WILLIAM's endpoints and integration points through a three-stage architecture.

## Core Components

### 1. Stage 1 (SKENAI)
```
[Raw] ÃƒÂ¢Ã¢â‚¬Â Ã¢â‚¬â„¢ [Initial] ÃƒÂ¢Ã¢â‚¬Â Ã¢â‚¬â„¢ [Basic]
  ÃƒÂ¢Ã¢â‚¬Â Ã¢â‚¬Ëœ        ÃƒÂ¢Ã¢â‚¬Â Ã¢â‚¬Â¢          ÃƒÂ¢Ã¢â‚¬Â Ã¢â‚¬Å“
[Log] ÃƒÂ¢Ã¢â‚¬Â Ã‚Â [Process] ÃƒÂ¢Ã¢â‚¬Â Ã‚Â [Check]
```
- /api/v2/skenai/submit
- /api/v2/skenai/validate
- /api/v2/skenai/status
- /api/v2/skenai/check
- /api/v2/skenai/log

### 2. Stage 2 (SKENAI-Q)
```
[Deep] ÃƒÂ¢Ã¢â‚¬Â Ã¢â‚¬â„¢ [Quality] ÃƒÂ¢Ã¢â‚¬Â Ã¢â‚¬â„¢ [Validate]
  ÃƒÂ¢Ã¢â‚¬Â Ã¢â‚¬Ëœ         ÃƒÂ¢Ã¢â‚¬Â Ã¢â‚¬Â¢           ÃƒÂ¢Ã¢â‚¬Â Ã¢â‚¬Å“
[Track] ÃƒÂ¢Ã¢â‚¬Â Ã‚Â [Assess] ÃƒÂ¢Ã¢â‚¬Â Ã‚Â [Review]
```
- /api/v2/quality/analyze
- /api/v2/quality/validate
- /api/v2/quality/review
- /api/v2/quality/assess
- /api/v2/quality/track

### 3. Stage 3 (SKENAI-R)
```
[Final] ÃƒÂ¢Ã¢â‚¬Â Ã¢â‚¬â„¢ [Deploy] ÃƒÂ¢Ã¢â‚¬Â Ã¢â‚¬â„¢ [Release]
  ÃƒÂ¢Ã¢â‚¬Â Ã¢â‚¬Ëœ         ÃƒÂ¢Ã¢â‚¬Â Ã¢â‚¬Â¢          ÃƒÂ¢Ã¢â‚¬Â Ã¢â‚¬Å“
[Monitor] ÃƒÂ¢Ã¢â‚¬Â Ã‚Â [Secure] ÃƒÂ¢Ã¢â‚¬Â Ã‚Â [Track]
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