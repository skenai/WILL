# System Architecture

[![WILL Version](https://img.shields.io/badge/WILL-v2.0.0-blue.svg)](https://github.com/shibakery/WILL/tree/v2.0.0)
[![Documentation](https://img.shields.io/badge/docs-current-green.svg)](https://github.com/shibakery/WILL/wiki)

WILL v2.0.0 implements a clean, three-tier architecture following the Market Coordination Protocol (MCP) standard.

## Architecture Overview

```
┌─────────────────────────────────────┐
│           Public Layer              │
│          (WILL Interface)           │
│   - Standard validation interfaces  │
│   - Network connection points       │
│   - Basic pattern recognition      │
│   - Market coordination            │
├─────────────────────────────────────┤
│         Private Layer               │
│       (SKENAI-R Core)              │
│   - Core validation logic          │
│   - Quantum processing             │
│   - Advanced patterns              │
│   - Evolution tracking             │
├─────────────────────────────────────┤
│         Quality Layer               │
│         (SKENAI-Q)                 │
│   - Pattern analysis               │
│   - Quality stages                 │
│   - Efficiency metrics             │
└─────────────────────────────────────┘
```

## Layer Responsibilities

### 1. Public Layer (WILL)
- Implements MCP standard interfaces
- Provides public API endpoints
- Handles basic validation
- Manages network coordination
- Routes requests to appropriate layers

### 2. Private Layer (SKENAI-R)
- Contains core validation logic
- Processes quantum computations
- Manages advanced pattern detection
- Tracks system evolution
- Maintains validator authority

### 3. Quality Layer (SKENAI-Q)
- Analyzes patterns
- Validates quality metrics
- Manages efficiency checks
- Coordinates with other layers
- Ensures system health

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
- Public Layer → Technical Graph
- Private Layer → Economic Graph
- Quality Layer → Quality Graph

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

### 1. Public Layer
```python
from will.public import WILLInterface

interface = WILLInterface()
interface.initialize_mcp()
interface.start_coordination()
```

### 2. Private Layer
```python
from skenai.core import CoreValidator

validator = CoreValidator()
validator.initialize_quantum()
validator.start_processing()
```

### 3. Quality Layer
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