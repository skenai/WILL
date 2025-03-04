# SKENAI XP Technical Guide

## System Overview

The XP system consists of several interconnected components that manage experience points throughout their lifecycle. This technical guide documents the implementation details of each component.

## Core Components

### 1. XP State Management
```typescript
interface XPState {
  userId: string;
  unallocatedXP: number;
  allocatedXP: number;
  decayedXP: number;
  lastUpdate: string;
  allocations: XPAllocation[];
}
```

The state management system tracks:
- Unallocated XP balances
- Allocated XP across tracks/tokens
- Decay history
- Last update timestamps

### 2. Transaction System
```typescript
type XPTransactionType = 
  | 'EARNED'    // New XP earned
  | 'DECAYED'   // Lost to decay
  | 'ALLOCATED' // Assigned to track/token
  | 'DEALLOCATED' // Removed from track/token
  | 'LOCKED'    // Temporarily locked
  | 'UNLOCKED'  // Released from lock
  | 'BURNED'    // Permanently removed
```

Each transaction includes:
- Amount
- Type
- Metadata (source, track, level)
- Timestamps
- User reference

### 3. Allocation System
```typescript
interface XPAllocation {
  userId: string;
  allocations: {
    target: 'TRACK' | 'TOKEN';
    id: string;
    amount: number;
    decayRate: number;
    lockPeriod?: number;
    bonusMultiplier?: number;
  }[];
}
```

Features:
- Track vs Token allocation
- Custom decay rates
- Optional lock periods
- Bonus multipliers

### 4. Decay System
```typescript
interface XPDecaySystem {
  baseDecayRate: number;     // 2% weekly
  minimumBalance: number;    // 100 XP
  allocatedXP: XPAllocation[];
  earlyAllocationBonus: {
    threshold: number;       // 7 days
    multiplier: number;      // 1.5x
  };
}
```

Key mechanics:
- Weekly base decay (2%)
- Protected minimum balance
- Reduced decay for allocations
- Early allocation bonuses

## Implementation Details

### 1. Decay Calculation
```typescript
function calculateDecay(
  amount: number,
  timePassed: number,
  decayRate: number,
  minimumBalance: number
): number {
  if (amount <= minimumBalance) return 0;
  const decayable = amount - minimumBalance;
  const decay = decayable * (1 - Math.pow(1 - decayRate, timePassed));
  return Math.min(decay, decayable);
}
```

### 2. Bonus Calculation
```typescript
function calculateAllocationBonus(
  amount: number,
  timeToAllocation: number,
  threshold: number,
  multiplier: number
): number {
  if (timeToAllocation > threshold) return 0;
  const bonusRatio = 1 - (timeToAllocation / threshold);
  return amount * (multiplier - 1) * bonusRatio;
}
```

## Database Schema

### XP State Table
```sql
CREATE TABLE xp_state (
  user_id TEXT PRIMARY KEY,
  unallocated_xp INTEGER NOT NULL DEFAULT 0,
  allocated_xp INTEGER NOT NULL DEFAULT 0,
  decayed_xp INTEGER NOT NULL DEFAULT 0,
  last_update TIMESTAMP NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
```

### XP Transactions Table
```sql
CREATE TABLE xp_transactions (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  amount INTEGER NOT NULL,
  type TEXT NOT NULL,
  metadata JSONB,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES xp_state(user_id)
);
```

### XP Allocations Table
```sql
CREATE TABLE xp_allocations (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  target_type TEXT NOT NULL,
  target_id TEXT NOT NULL,
  amount INTEGER NOT NULL,
  decay_rate REAL NOT NULL,
  lock_period INTEGER,
  bonus_multiplier REAL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES xp_state(user_id)
);
```

## Usage Examples

### 1. Earning XP
```typescript
// Award XP for completing a task
await xpManager.awardXP(userId, {
  amount: 1000,
  type: 'EARNED',
  metadata: {
    source: 'task_completion',
    track: 'RESEARCH',
    level: 'L1'
  }
});
```

### 2. Allocating XP
```typescript
// Allocate XP to a research track
await xpManager.allocateXP(userId, {
  target: 'TRACK',
  id: 'research_track_1',
  amount: 500,
  lockPeriod: 30 * 24 * 60 * 60 * 1000 // 30 days
});
```

### 3. Processing Decay
```typescript
// Weekly decay job
async function weeklyDecay() {
  const users = await getActiveUsers();
  for (const user of users) {
    await xpManager.processDecay(user.id, new Date().toISOString());
  }
}
```

## Best Practices

1. **State Management**
   - Always use transactions for state changes
   - Validate state before updates
   - Keep audit trail of all changes

2. **Decay Processing**
   - Run decay jobs on schedule
   - Handle failed jobs gracefully
   - Monitor decay rates

3. **Allocation Strategy**
   - Encourage early allocation
   - Balance lock periods
   - Monitor allocation patterns

4. **Performance**
   - Index transaction queries
   - Batch decay processing
   - Cache active user states

## Related Documentation
- [Research and XP](Research-and-XP.md)
- [Token System](Token-System.md)
- [GFORCE Framework](GFORCE-Framework.md)


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