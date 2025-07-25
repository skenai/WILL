---
version: 2.0.0
date: 2025-03-04
type: system-doc
status: public
tags: [william, quickstart]
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
# Quick Start Guide

## Overview
This guide will help you get started with WILL and the SKENAI ecosystem quickly.

## Prerequisites
- GitHub account
- Basic understanding of blockchain concepts
- Familiarity with Web3 development

## Setup Steps

### 1. System Access
1. Join the SKENAI DAO
2. Get your API keys
3. Set up authentication

### 2. Basic Integration
```typescript
import { WILL } from '@skenai/will-sdk';

// Initialize WILL
const will = new WILL({
  apiKey: 'your-api-key',
  environment: 'production'
});

// Start using WILL's features
const proposal = await will.createProposal({
  track: 'G',
  level: 'L0',
  title: 'My First Proposal'
});
```

### 3. Next Steps
1. Explore the [Technical Implementation](Technical-Implementation)
2. Review [Best Practices](https://sken.ai/best-practices)
3. Join our [Community](Community)

## Common Use Cases

### 1. Proposal Creation
- Using templates
- Quality metrics
- Validation process

### 2. Value Analysis
- 3D value space
- Pattern recognition
- Network effects

### 3. Track Management
- GFORCE framework
- Level progression
- XP allocation

## Additional Resources
- [API Documentation](API)
- [SDK Guide](SDK)
- [Examples](Examples)
- [FAQs](FAQ)
