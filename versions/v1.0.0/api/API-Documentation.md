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
# API Documentation

## Authentication

WILL uses OAuth 2.0 for authentication. Detailed setup instructions will be provided here.

## API Endpoints

### Social Intelligence

```typescript
POST /api/v1/analyze
{
    "content": string,
    "context": Object,
    "parameters": Object
}
```

### Governance Integration

```typescript
POST /api/v1/proposals
{
    "type": "proposal",
    "content": Object,
    "metadata": Object
}
```

## Rate Limits

- Standard tier: 1000 requests/hour
- Enterprise tier: Custom limits

## Error Handling

Standard error responses follow this format:
```json
{
    "error": {
        "code": "ERROR_CODE",
        "message": "Human readable message",
        "details": {}
    }
}
```

## SDK Support

Official SDKs will be provided for:
- JavaScript/TypeScript
- Python
- Rust

## Related Pages
- [[Integration-Guide]]
- [[Architecture]]
- [[FAQ]]
