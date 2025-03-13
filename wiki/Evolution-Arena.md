# Evolution Arena

The Evolution Arena is WILL's advanced validation framework that combines CHANDELIER's edge evolution mechanics with WILLPOWER's XP scaling system. This chapter details the mathematical models, economic formulas, and implementation guidelines for the MVP launch.

## Overview

Evolution Arena introduces a novel approach to network validation through:
- Dynamic edge strength evolution
- Challenge-based validation
- Economic incentives through seat ownership
- XP scaling based on network size

## CHANDELIER Components

### Edge Evolution
```solidity
edge_strength_growth = min(
    current_strength * (1 + (quality_score * type_weights[type])),
    MAX_EDGE_STRENGTH
)
```

Challenge Types and Weights:
1. TOKEN_METRICS (1.0x): Value validation
2. SECURITY (1.2x): Edge protection
3. EFFICIENCY (1.1x): Pattern optimization
4. NETWORK (1.3x): Graph properties
5. VALIDATION (1.4x): Proof verification
6. FOUNDATION (1.5x): Hash chain verification

### Price Components
Base Price: $2,500 USD
```solidity
total_price = base_price + staking_value + challenge_impact + edge_value

where:
staking_value = (staked_amount * edge_strength * base_price) / (max_stake * max_edge)
challenge_impact = quality_score * max_impact
edge_value = edge_strength / scale_factor
```

Example Calculation:
```
Initial Seat ($2,990.90):
- Base: $2,500
- Staking (1M, 0.9): $90
- Challenge (0.8): $400
- Edge (0.9): $0.90

After FOUNDATION ($3,001.00):
- Base: $2,500
- Staking (1M, 1.0): $100
- Challenge (0.8): $400
- Edge (1.0): $1.00
```

## WILLPOWER Integration

### XP Scaling Model
```python
network_cap = min(
    base_xp * 2,                          # 21,000 XP minimum
    max(
        base_xp * network_size/100,       # Linear scaling
        50_000 * network_size/24_000      # Original formula
    )
)
```

Base XP Components:
- Chat Activity: 5,000 XP
- Staking: 5,500 XP
- Total Base: 10,500 XP

Network Scaling:
- MVP (100 seats): 21,000 XP/action
- Phase 3 (1,000 seats): 105,000 XP
- Final (6,000 seats): 750M XP/month

## MVP Implementation

### Seat Distribution
- Total Seats: 100
- FOUNDATION Access: First 10 seats
- Price: $2,500 per seat
- Staking Requirement: 1M SHIBAK per seat

### Economic Model
- Initial TVL: $250,000
- Target TVL: $300,000
- Phase 3 Target: $5.61M
- Daily Transactions: 100
- Monthly XP: 210M

### Timeline
1. Week 1 (March 13-18):
   - Deploy EdgeEvolution contract
   - Test edge strength evolution
   - Verify price calculations

2. Week 2 (March 19-25):
   - Integrate WILLPOWER XP system
   - Test network scaling
   - Add FOUNDATION challenge type

3. Week 3-4 (March 26-April 12):
   - Launch pre-sale campaign
   - Onboard first 10 FOUNDATION seats
   - Begin network validation

## Integration Guide

### Contract Addresses (Fuji Testnet)
```solidity
SHIBAK Token: [TBD]
Seat Token: [TBD]
EdgeEvolution: [TBD]
PriceCalculator: [TBD]
```

### Key Functions

1. Edge Evolution:
```solidity
function evolveEdge(
    uint256 seatId,
    uint8 challengeType,
    uint256 qualityScore
) external;
```

2. Price Calculation:
```solidity
function calculatePrice(uint256 seatId) 
    public view returns (uint256);
```

3. Staking:
```solidity
function updateStake(
    uint256 seatId,
    uint256 amount
) external;
```

### Safety Features
1. Challenge Cooldown: 1 day
2. Quality Score Range: 0-1000 (3 decimals)
3. Edge Strength Cap: 1.0 (1000)
4. Input Validation
5. Reentrancy Protection

## Future Development

### Phase 3 Goals
1. Scale to 1,000 seats
2. Increase XP rewards to 105,000 per action
3. Achieve $5.61M TVL
4. Expand challenge types
5. Enhance edge evolution mechanics

### Research Areas
1. Dynamic weight adjustment
2. Network topology optimization
3. Challenge impact modeling
4. XP distribution efficiency
5. Economic equilibrium studies

## References
1. [GFORCE Framework](GFORCE-Framework)
2. [Token System](Token-System)
3. [Research and XP](Research-and-XP)
4. [Strategic Evolution](Strategic-Evolution)
