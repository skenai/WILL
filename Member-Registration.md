# SKENAI DAO Member Registration and Tracking

## Overview

The SKENAI DAO uses a multi-faceted approach to member registration and engagement tracking, allowing members to choose their preferred authentication methods while maintaining privacy options.

## Registration Methods

### 1. Web3 Authentication
```yaml
Wallet Integration:
  - ERC20 Wallet Connect
  - Supported Networks:
    - Ethereum Mainnet
    - Polygon
    - Arbitrum
  Initial XP Reward: 500 XP
```

### 2. Social Authentication
```yaml
Platforms:
  Farcaster:
    - Integration: Native
    - XP Reward: 300 XP
    - Benefits: Direct interaction with William
  
  Twitter:
    - Integration: OAuth2
    - XP Reward: 200 XP
    - Benefits: Automated engagement tracking

  Email (Optional):
    - Purpose: Newsletter and updates
    - XP Reward: 100 XP
    - Privacy: Opt-in only
```

## Member Identity System

### Primary Identifiers
1. **0x Address**: Unique wallet address
2. **DAO ID**: Generated unique identifier
3. **Social Handles**: Connected accounts

### Privacy Options
```yaml
Privacy Levels:
  Anonymous:
    - Only 0x address visible
    - Pseudonymous participation
  
  Connected:
    - Social handles visible
    - Email notifications enabled
    
  Public:
    - Full profile visible
    - Blog contribution enabled
```

## Referral Program

### Structure
```yaml
Referral Rewards:
  Base:
    Referrer: 1000 XP
    Referee: 500 XP
  
  Multipliers:
    Active_Member: 1.5x
    Core_Contributor: 2x
    Council_Member: 3x

  Token Distribution:
    SHIBAKEN: 40%
    SBX: 30%
    EVS: 30%
```

### Tracking
- Unique referral links
- Smart contract verification
- Social proof validation

## Leaderboard System

### Categories
1. **Overall Contribution**
   - Total XP earned
   - Proposals completed
   - Community engagement

2. **Track-Specific**
   - Genesis Track
   - Research Track
   - Community Track
   - Evolution Track

3. **Social Engagement**
   - Farcaster participation
   - Twitter engagement
   - Blog contributions

### Rewards
```yaml
Weekly_Rewards:
  Top_3:
    First: 5000 XP + NFT Badge
    Second: 3000 XP
    Third: 2000 XP
  
  Track_Leaders:
    XP_Bonus: 1000 XP
    Multiplier: 1.5x next week

Monthly_Rewards:
  Consistency_Bonus: 2x weekly rewards
  Special_NFT: Limited edition
  Governance_Weight: +10% voting power
```

## Integration Points

### 1. Smart Contract Integration
```solidity
interface IMemberRegistry {
    function register(address wallet) external returns (uint256 daoId);
    function linkSocial(uint256 daoId, string calldata platform, string calldata handle) external;
    function updatePrivacy(uint256 daoId, uint8 privacyLevel) external;
    function getReferralRewards(address referrer, address referee) external view returns (uint256);
}
```

### 2. API Endpoints
```yaml
Registration:
  - POST /api/v1/register
  - POST /api/v1/link-social
  - PUT /api/v1/privacy-settings

Leaderboard:
  - GET /api/v1/leaderboard/global
  - GET /api/v1/leaderboard/track/{trackId}
  - GET /api/v1/member/{daoId}/stats
```

### 3. Event Tracking
```yaml
Events:
  Member:
    - Registration
    - Social Link
    - Privacy Update
    - XP Earned
  
  Referral:
    - Link Generation
    - Successful Referral
    - Reward Distribution
  
  Engagement:
    - Proposal Creation
    - Vote Participation
    - Social Interaction
```

## Website Design

### Landing Page
```yaml
Components:
  Hero:
    - DAO Mission Statement
    - Registration CTA
    - Current Statistics
  
  Features:
    - XP System Overview
    - Contribution Tracks
    - Reward Structure
  
  Social Proof:
    - Member Testimonials
    - Project Showcases
    - Partnership Highlights
```

### Member Dashboard
```yaml
Sections:
  Profile:
    - DAO ID
    - Connected Accounts
    - Privacy Settings
  
  Activity:
    - XP History
    - Contribution Log
    - Rewards Earned
  
  Engagement:
    - Active Proposals
    - Voting Power
    - Social Metrics
```

### Registration Flow
1. Connect Wallet
2. Choose Privacy Level
3. Optional Social Links
4. Email Opt-in
5. Welcome Package

## Implementation Plan

### Phase 1: Core Registration
- Wallet integration
- Basic profile system
- XP tracking

### Phase 2: Social Integration
- Farcaster integration
- Twitter connection
- Email system

### Phase 3: Engagement Features
- Leaderboard implementation
- Referral system
- Enhanced analytics

### Phase 4: Advanced Features
- NFT badges
- Enhanced privacy options
- Cross-platform integration

## Success Metrics

```yaml
Adoption:
  Target:
    Daily_Registrations: 100
    Referral_Rate: 30%
    Social_Links: 50%

Engagement:
  Metrics:
    Active_Members: 70%
    Weekly_Contributions: 5/member
    Social_Interactions: 10/member/day

Retention:
  Goals:
    30_Day: 80%
    90_Day: 60%
    Annual: 40%

Token Allocation
```yaml
Distribution:
     SHIBAKEN: 40%  # Core governance and participation
     SBX: 30%       # Network value measurement
     BSTBL: 20%     # Stability mechanism
     SBV: 10%       # Value flow tracking
