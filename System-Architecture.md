# System Architecture

[![WILL Version](https://img.shields.io/badge/WILL-v2.0.0-blue.svg)](https://github.com/shibakery/WILL/tree/v2.0.0)
[![Documentation](https://img.shields.io/badge/docs-current-green.svg)](https://github.com/shibakery/WILL/wiki)

WILL v2.0.0 implements a clean, three-tier architecture following the Market Coordination Protocol (MCP) standard.

## Architecture Overview

```
┌─────────────────────────────────────┐
│           Stage 1: SKENAI           │
│          (Initial Hopper)           │
│   - Raw content intake             │
│   - Initial processing             │
│   - Basic validation               │
│   - Content categorization         │
├─────────────────────────────────────┤
│         Stage 2: SKENAI-Q           │
│          (Quality Gate)             │
│   - Proposal validation            │
│   - Security enforcement           │
│   - Quality assessment             │
│   - Staging verification           │
├─────────────────────────────────────┤
│         Stage 3: SKENAI-R           │
│          (Release Gate)             │
│   - Final verification             │
│   - Production deployment          │
│   - Public distribution            │
│   - Access management              │
└─────────────────────────────────────┘
```

## Layer Responsibilities

### 1. Stage 1 (SKENAI)
- Handles raw content intake
- Performs initial processing
- Basic validation checks
- Content categorization
- Preliminary security scanning

### 2. Stage 2 (SKENAI-Q)
- Validates proposals (100+ proposals)
- Enforces security protocols
- Assesses quality metrics
- Manages staging environment
- Executes test suites

### 3. Stage 3 (SKENAI-R)
- Final verification checks
- Production deployment
- Public distribution
- Access management
- Documentation updates

## Natural Pipeline Flow

```
┌──────────┐    ┌──────────┐    ┌──────────┐
│  SKENAI  │ -> │ R-prop   │ -> │   Q.1    │
└──────────┘    └──────────┘    └──────────┘
                                      │
┌──────────┐    ┌──────────┐    ┌──────────┐
│ R-final  │ <- │   Vote   │ <- │   Q.2    │
└──────────┘    └──────────┘    └──────────┘
```

## Integration Points

### 1. Three-Graph Lattice
Each layer participates in the Three-Graph Lattice:
- Stage 1: SKENAI → Technical Graph
- Stage 2: SKENAI-Q → Economic Graph
- Stage 3: SKENAI-R → Quality Graph

### 2. NATURAL Framework
The architecture implements NATURAL principles:
1. Clean repository separation
2. Natural pipeline flow
3. Validator protection
4. Interface standards

### 3. MCP Standard
Public interfaces follow MCP requirements:
- Standard validation interfaces
- Network coordination rules
- Agent interaction protocols
- Market validation patterns

## Security Architecture

### 1. Layer Protection
```
┌────────────────┐
│  Public API    │ ← HTTPS, API Keys
├────────────────┤
│  Private Core  │ ← Vote Gates, Auth
├────────────────┤
│  Quality Layer │ ← Pattern Validation
└────────────────┘
```

### 2. Data Flow Security
- Request signing required
- Rate limiting enforced
- Validator authority respected
- Pattern validation required
- Access control maintained

### 3. Validator Protection
- Core stays private
- Vote gates for changes
- Pattern emergence preserved
- Natural movement maintained

## Implementation Guidelines

### 1. Stage 1 (SKENAI)
```python
from will.public import WILLInterface

interface = WILLInterface()
interface.initialize_mcp()
interface.start_coordination()
```

### 2. Stage 2 (SKENAI-Q)
```python
from skenai.core import CoreValidator

validator = CoreValidator()
validator.initialize_quantum()
validator.start_processing()
```

### 3. Stage 3 (SKENAI-R)
```python
from skenai.quality import QualityAnalyzer

analyzer = QualityAnalyzer()
analyzer.initialize_patterns()
analyzer.start_analysis()
```

## Deployment Architecture

### 1. Repository Structure
```
will/
├── public/           # Public API
│   ├── api/         # Endpoints
│   └── docs/        # Documentation
├── private/         # Core logic
│   ├── validators/  # R validators
│   └── quantum/     # Processing
└── quality/         # Q analysis
    ├── patterns/    # Detection
    └── metrics/     # Evaluation
```

### 2. Network Architecture
```
[Clients] → [Public API] → [Load Balancer]
                              │
                        ┌─────┴─────┐
                        ▼           ▼
                  [Private]    [Quality]
```

## Version Changes

### New in v2.0.0
1. MCP standard implementation
2. Three-Graph Lattice integration
3. Enhanced security model
4. Clean repository separation
5. Natural pipeline flow

### Migration Notes
- Update to MCP interfaces
- Implement Three-Graph Lattice
- Enable validator protection
- Add security enhancements

## Getting Started

For detailed implementation guidance:
1. Review [Technical Implementation](Technical-Implementation)
2. Study [Three-Stage Architecture](Three-Stage-Architecture)
3. Understand [Security Protocols](Security-Protocols)
4. Follow [Development Guide](Development)
5. Consult [API Reference](API-Reference)

## Pipeline API Integration
- /pipeline/submit - Entry point
- /pipeline/validate - Basic checks
- /pipeline/analyze - Efficiency (Q.1)
- /pipeline/patterns - Recognition (Q.2)
- /pipeline/status - State checks
- /pipeline/vote - Governance