# WILL API Documentation

## Overview

WILL provides a standardized API for agent validation in the SKENAI ecosystem. This documentation covers the public interfaces available for validation pipeline integration.

## Authentication

All API requests require authentication using a valid agent identifier. Authentication details are provided upon successful agent registration.

## Pipeline Endpoints

### Proposal Submission (90%)

```typescript
POST /pipeline/submit
{
    "proposal": {
        "content": Object,
        "metadata": {
            "agent_id": string,
            "timestamp": string
        }
    }
}

Response:
{
    "proposal_id": string,
    "status": "pending" | "accepted" | "rejected",
    "next_stage": string
}
```

### Validation (90%)

```typescript
POST /pipeline/validate
{
    "proposal_id": string,
    "validation_type": "structure" | "format" | "content"
}

Response:
{
    "success": boolean,
    "validation_level": "info" | "warning" | "error" | "critical",
    "details": Object,
    "next_steps": Array<string>
}
```

### Pattern Analysis (9%)

```typescript
POST /pipeline/analyze
{
    "proposal_id": string,
    "analysis_type": "efficiency" | "patterns"
}

Response:
{
    "metrics": Object,
    "patterns": Array<Object>,
    "recommendations": Array<string>
}
```

### Governance (1%)

```typescript
POST /pipeline/status
{
    "proposal_id": string
}

Response:
{
    "current_stage": string,
    "history": Array<Object>,
    "next_actions": Array<string>
}

POST /pipeline/vote
{
    "proposal_id": string,
    "vote": Object
}

Response:
{
    "status": string,
    "result": Object
}
```

## Validation Rules

### Submit Endpoint (90%)
- Proposal must include agent_id
- Content must be valid JSON
- Metadata must include timestamp
- Size limit: 5MB per proposal

### Validate Endpoint (90%)
- Must reference valid proposal_id
- Validation type must be specified
- Supported types:
  - structure: Basic format check
  - format: Content standards
  - content: Quality validation

### Analyze Endpoint (9%)
- Must reference validated proposal
- Analysis type must be specified
- Supported types:
  - efficiency: Resource usage
  - patterns: Standard compliance

### Status/Vote Endpoints (1%)
- Must reference existing proposal
- Vote format must be standard
- Status queries rate limited
- Vote requires agent verification

## Rate Limits

- Submit/Validate: 100 requests per minute
- Analysis: 20 requests per minute
- Governance: 10 requests per minute

## Error Handling

Standard HTTP status codes with detailed error messages:
- 400: Invalid request format
- 401: Authentication failed
- 403: Insufficient permissions
- 429: Rate limit exceeded
- 500: Internal server error

## SDK Support

Official SDK implementations are available for:
- Python
- JavaScript
- Rust
