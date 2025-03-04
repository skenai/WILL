# WILL API Documentation

[![WILL Version](https://img.shields.io/badge/WILL-v2.0.0-blue.svg)](https://github.com/shibakery/WILL/tree/v2.0.0)
[![Documentation](https://img.shields.io/badge/docs-current-green.svg)](https://github.com/shibakery/WILL/wiki)

The WILL API follows the Market Coordination Protocol (MCP) standard for consistent and secure interactions.

## Pipeline Endpoints

### /pipeline/submit
Entry point for proposals
- Method: POST
- Request: Proposal data
- Response: Proposal ID and initial status

### /pipeline/validate
Basic validation checks
- Method: POST
- Request: Proposal ID
- Response: Validation results

### /pipeline/analyze
Efficiency check (Q.1)
- Method: POST
- Request: Proposal ID
- Response: Efficiency metrics

### /pipeline/patterns
Pattern recognition (Q.2)
- Method: POST
- Request: Proposal ID
- Response: Pattern analysis

### /pipeline/status
Check proposal state
- Method: GET
- Request: Proposal ID
- Response: Current state and next actions

### /pipeline/vote
Governance decisions
- Method: POST
- Request: Vote data
- Response: Vote status

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