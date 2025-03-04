---
version: 2.0.0
date: 2025-03-04
type: api-doc
status: public
tags: [william, api, reference]
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
# API Reference

WILL v2.0.0 implements the Market Coordination Protocol (MCP) standard for consistent and secure network interactions.

## Overview

The SKENAI API provides programmatic access to the system's core functionality, enabling integration with external systems and custom implementations. This reference documents the available endpoints, data structures, and integration patterns.

## API Structure

### 1. Core Endpoints

#### System Management
```
GET    /api/v1/system/status
GET    /api/v1/system/health
POST   /api/v1/system/configure
PUT    /api/v1/system/update
DELETE /api/v1/system/cache
```

#### Data Processing
```
POST   /api/v1/data/process
GET    /api/v1/data/status/{id}
GET    /api/v1/data/result/{id}
DELETE /api/v1/data/cancel/{id}
```

#### Model Management
```
GET    /api/v1/models/list
POST   /api/v1/models/train
GET    /api/v1/models/status/{id}
PUT    /api/v1/models/update/{id}
DELETE /api/v1/models/remove/{id}
```

### 2. Authentication

#### Token Management
```
POST   /api/v1/auth/token
GET    /api/v1/auth/verify
POST   /api/v1/auth/refresh
DELETE /api/v1/auth/revoke
```

#### Access Control
```
GET    /api/v1/auth/permissions
POST   /api/v1/auth/grant
DELETE /api/v1/auth/revoke
```

### 3. Integration Points

#### Webhooks
```
POST   /api/v1/webhooks/register
GET    /api/v1/webhooks/list
DELETE /api/v1/webhooks/remove
```

#### Events
```
GET    /api/v1/events/stream
POST   /api/v1/events/publish
GET    /api/v1/events/history
```

### 4. Pipeline API

#### Proposal Submission

```typescript
POST /pipeline/submit
{
    "proposal": {
        "content": string,
        "metadata": {
            "type": "technical" | "economic" | "quality",
            "version": "2.0.0",
            "timestamp": string
        }
    }
}

Response:
{
    "status": "success",
    "data": {
        "proposal_id": string,
        "status": "pending_validation",
        "next_stage": "validation"
    }
}
```

#### Validation

```typescript
POST /pipeline/validate
{
    "proposal_id": string,
    "validation_type": "technical" | "economic" | "quality"
}

Response:
{
    "status": "success",
    "data": {
        "validation_results": {
            "passed": boolean,
            "metrics": Object,
            "next_stage": "analyze" | "rejected"
        }
    }
}
```

#### Pattern Analysis (Q.1)

```typescript
POST /pipeline/analyze
{
    "proposal_id": string,
    "analysis_type": "efficiency" | "security" | "quality"
}

Response:
{
    "status": "success",
    "data": {
        "efficiency_score": number,
        "patterns_detected": string[],
        "recommendations": Object
    }
}
```

#### Pattern Recognition (Q.2)

```typescript
POST /pipeline/patterns
{
    "proposal_id": string,
    "pattern_context": {
        "technical": Object,
        "economic": Object,
        "quality": Object
    }
}

Response:
{
    "status": "success",
    "data": {
        "patterns": Object[],
        "confidence": number,
        "impact_analysis": Object
    }
}
```

#### Status Check

```typescript
GET /pipeline/status/{proposal_id}

Response:
{
    "status": "success",
    "data": {
        "current_stage": string,
        "history": Object[],
        "next_actions": string[]
    }
}
```

#### Governance Vote

```typescript
POST /pipeline/vote
{
    "proposal_id": string,
    "vote": {
        "decision": "approve" | "reject",
        "rationale": string,
        "validator_id": string
    }
}

Response:
{
    "status": "success",
    "data": {
        "vote_recorded": boolean,
        "current_status": string,
        "vote_summary": Object
    }
}
```

## Data Structures

### 1. Request Format
```json
{
  "requestId": "string",
  "timestamp": "ISO8601",
  "data": {
    "type": "string",
    "content": "object"
  },
  "metadata": {
    "version": "string",
    "source": "string"
  }
}
```

### 2. Response Format
```json
{
  "requestId": "string",
  "timestamp": "ISO8601",
  "status": {
    "code": "number",
    "message": "string"
  },
  "data": "object",
  "metadata": {
    "version": "string",
    "processingTime": "number"
  }
}
```

### 3. Error Format
```json
{
  "requestId": "string",
  "timestamp": "ISO8601",
  "error": {
    "code": "string",
    "message": "string",
    "details": "object"
  }
}
```

## Authentication

### 1. Token-Based Auth
```
Authorization: Bearer <token>
```

### 2. API Keys
```
X-API-Key: <api_key>
```

### 3. OAuth2 Flow
1. Authorization request
2. Token exchange
3. Access token usage
4. Token refresh
5. Token revocation

## Rate Limiting

### 1. Default Limits
- 1000 requests per minute
- 10000 requests per hour
- 100000 requests per day

### 2. Headers
```
X-RateLimit-Limit: <limit>
X-RateLimit-Remaining: <remaining>
X-RateLimit-Reset: <reset_time>
```

### 3. Status Codes
- 200: Success
- 429: Too Many Requests
- 503: Service Unavailable

## Versioning

### 1. URL Versioning
```
/api/v1/...
/api/v2/...
```

### 2. Header Versioning
```
Accept: application/vnd.skenai.v1+json
```

### 3. Version Lifecycle
- Development
- Beta
- Stable
- Deprecated
- Sunset

## Security

### 1. Transport Security
- HTTPS required
- TLS 1.2+
- Certificate validation
- Cipher suite restrictions

### 2. Request Security
- Request signing
- Timestamp validation
- Nonce checking
- Payload validation

### 3. Response Security
- Response signing
- Data encryption
- Integrity checking
- Error masking

## Best Practices

### 1. Implementation
- Use HTTPS
- Implement rate limiting
- Handle errors gracefully
- Cache responses
- Log requests

### 2. Development
- Follow REST principles
- Use proper HTTP methods
- Include proper headers
- Validate input
- Handle timeouts

### 3. Operations
- Monitor usage
- Track errors
- Update documentation
- Maintain versions
- Support users

## Getting Started

1. [Register for API access](API-Reference#registration)
2. [Get authentication credentials](API-Reference#authentication)
3. [Make your first request](API-Reference#quickstart)
4. [Handle responses](API-Reference#responses)
5. [Implement error handling](API-Reference#errors)

## Integration with NATURAL Framework
- Clean repository separation
- Natural pipeline flow
- Validator protection
- Interface standards

## Three-Graph Lattice Integration
- Technical graph validation
- Economic resource optimization
- Quality metrics tracking

## Pipeline API Integration
- /pipeline/submit - Entry point
- /pipeline/validate - Basic checks
- /pipeline/analyze - Efficiency (Q.1)
- /pipeline/patterns - Recognition (Q.2)
- /pipeline/status - State checks
- /pipeline/vote - Governance

## SDK Support

Official SDKs:
- [JavaScript/TypeScript](https://github.com/shibakery/will-js)
- [Python](https://github.com/shibakery/will-py)
- [Rust](https://github.com/shibakery/will-rs)

## Error Handling

All errors follow the standard format:

```typescript
{
    "status": "error",
    "error": {
        "code": string,
        "message": string,
        "details": Object
    }
}
```

Common error codes:
- `INVALID_REQUEST`: Malformed request
- `UNAUTHORIZED`: Missing or invalid credentials
- `RATE_LIMITED`: Too many requests
- `VALIDATION_FAILED`: Failed validation checks
- `PROPOSAL_NOT_FOUND`: Invalid proposal ID
- `STAGE_VIOLATION`: Invalid pipeline stage transition

## Security Considerations

1. All endpoints use HTTPS
2. Request signing required
3. Rate limiting enforced
4. Validator authority respected
5. Vote gates for major changes