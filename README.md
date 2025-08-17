# Decentralized Reputation System

A blockchain-based reputation system built on Ethereum using Solidity and Foundry, enabling users to rate each other in a trustless, transparent manner.

## Overview

This decentralized reputation system allows users to build and maintain reputation scores through peer-to-peer ratings. The system implements anti-gaming mechanisms, dispute resolution, and weighted scoring to ensure fair and reliable reputation tracking.

### Key Features

- **Peer-to-Peer Rating**: Users can rate each other on a configurable scale
- **Weighted Reputation**: Ratings from higher-reputation users carry more weight
- **Anti-Gaming Protection**: Cooldown periods, Sybil resistance, and rating limits
- **Dispute Resolution**: Built-in mechanism for challenging unfair ratings
- **Reputation Decay**: Time-based reputation decay to keep scores current
- **Profile Management**: User profiles with metadata and rating history
- **Access Control**: Role-based permissions for system administration

## Architecture

### Smart Contracts

```
src/
├── core/
│   ├── ReputationRegistry.sol     # Main reputation storage and calculation
│   ├── RatingSystem.sol           # Rating submission and validation
│   └── UserProfile.sol            # User profile management
├── governance/
│   ├── AccessControl.sol          # Role-based permissions
│   └── DisputeResolution.sol      # Rating dispute handling
├── token/
│   └── ReputationToken.sol        # Optional tokenized reputation
└── interfaces/
    ├── IReputationRegistry.sol
    ├── IRatingSystem.sol
    ├── IUserProfile.sol
    └── IDisputeResolution.sol
```

### Contract Interactions

1. **User Registration**: Users register through `UserProfile.sol`
2. **Rating Submission**: Ratings submitted via `RatingSystem.sol`
3. **Reputation Update**: `RatingSystem.sol` calls `ReputationRegistry.sol` to update scores
4. **Dispute Process**: Unfair ratings can be disputed through `DisputeResolution.sol`


## Getting Started

### Prerequisites

- [Foundry](https://github.com/foundry-rs/foundry)
- [Git](https://git-scm.com/)

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd build
```

2. Install Foundry dependencies:
```bash
forge install
```

3. Install additional dependencies:
```bash
forge install OpenZeppelin/openzeppelin-contracts
forge install foundry-rs/forge-std
```

### Configuration

Create a `.env` file in the root directory:
```env
# RPC URLs
ETHEREUM_RPC_URL=https://eth-mainnet.g.alchemy.com/v2/your-key
GOERLI_RPC_URL=https://eth-goerli.g.alchemy.com/v2/your-key
SEPOLIA_RPC_URL=https://eth-sepolia.g.alchemy.com/v2/your-key

# Private keys (for deployment)
PRIVATE_KEY=your-private-key

# Etherscan API (for verification)
ETHERSCAN_API_KEY=your-etherscan-api-key

# System Configuration
INITIAL_REPUTATION_SCORE=100
RATING_SCALE_MAX=5
RATING_COOLDOWN_PERIOD=86400  # 24 hours in seconds
REPUTATION_DECAY_RATE=1       # 1% per month
```

## Usage

### Compilation

```bash
forge build
```

### Testing

Run all tests:
```bash
forge test
```

Run tests with gas reporting:
```bash
forge test --gas-report
```

Run specific test file:
```bash
forge test --match-path test/ReputationRegistry.t.sol
```

### Deployment

Deploy to local network:
```bash
anvil  # Start local node
forge script script/Deploy.s.sol --rpc-url http://localhost:8545 --private-key $PRIVATE_KEY --broadcast
```

Deploy to testnet:
```bash
forge script script/Deploy.s.sol --rpc-url $SEPOLIA_RPC_URL --private-key $PRIVATE_KEY --broadcast --verify
```

### Contract Verification

```bash
forge verify-contract <CONTRACT_ADDRESS> src/core/ReputationRegistry.sol:ReputationRegistry --etherscan-api-key $ETHERSCAN_API_KEY --chain sepolia
```

## Smart Contract Details

### ReputationRegistry.sol

The core contract managing reputation scores and calculations.

**Key Functions:**
- `getReputationScore(address user)`: Get current reputation score
- `updateReputation(address user, uint256 newRating, address rater)`: Update reputation (internal)
- `calculateWeightedScore(address user)`: Calculate weighted reputation score
- `applyDecay(address user)`: Apply time-based reputation decay

**Events:**
- `ReputationUpdated(address indexed user, uint256 newScore, uint256 timestamp)`
- `ReputationDecayed(address indexed user, uint256 oldScore, uint256 newScore)`

### UserProfile.sol

Manages user profiles and metadata.

**Key Functions:**
- `registerUser(string memory username, string memory metadata)`: Register new user
- `updateProfile(string memory metadata)`: Update user profile
- `getUserProfile(address user)`: Get user profile information
- `isRegistered(address user)`: Check if user is registered

### DisputeResolution.sol

Handles disputes over ratings.

**Key Functions:**
- `submitDispute(address rater, address ratee, string memory reason)`: Submit dispute
- `voteOnDispute(uint256 disputeId, bool support)`: Vote on dispute
- `resolveDispute(uint256 disputeId)`: Resolve dispute
- `getDispute(uint256 disputeId)`: Get dispute details

## Testing Strategy

### Unit Tests

Located in `test/` directory:
- `ReputationRegistry.t.sol`: Core reputation logic tests
- `RatingSystem.t.sol`: Rating submission and validation tests
- `UserProfile.t.sol`: Profile management tests
- `DisputeResolution.t.sol`: Dispute mechanism tests
- `Integration.t.sol`: Cross-contract integration tests

### Test Categories
1. **Functionality Tests**: Verify core features work as expected
2. **Security Tests**: Test access controls and attack vectors
3. **Gas Optimization Tests**: Ensure efficient gas usage
4. **Edge Case Tests**: Handle boundary conditions and errors
5. **Integration Tests**: Test contract interactions

### Running Specific Test Categories

```bash
# Security tests
forge test --match-test testSecurity

# Gas optimization tests
forge test --gas-report --match-test testGas

# Integration tests
forge test --match-path test/Integration.t.sol
```

## Security Considerations
### Anti-Gaming Mechanisms

1. **Cooldown Periods**: Prevent spam ratings
2. **Rating Limits**: Limit number of ratings per user per time period
3. **Weighted Scoring**: Higher reputation users have more influence
4. **Sybil Resistance**: Minimum reputation threshold for meaningful ratings


### Access Control

- **Admin Role**: Contract deployment and emergency functions
- **Moderator Role**: Dispute resolution and content moderation
- **User Role**: Standard user functions

### Known Risks

1. **Sybil Attacks**: Mitigated through reputation weighting and minimum thresholds
2. **Collusion**: Monitoring and dispute mechanisms help detect coordinated attacks
3. **Rating Manipulation**: Cooldowns and limits reduce manipulation potential
4. **Front-running**: Consider commit-reveal schemes for sensitive operations

## Gas Optimization

### Strategies Implemented

1. **Packed Structs**: Optimize storage layout
2. **Batch Operations**: Process multiple ratings in single transaction
3. **Event Indexing**: Use indexed parameters efficiently
4. **Storage vs Memory**: Optimize variable declarations

### Gas Usage Estimates

| Function | Estimated Gas |
|----------|---------------|
| Register User | ~50,000 |
| Submit Rating | ~80,000 |
| Update Reputation | ~45,000 |
| Submit Dispute | ~120,000 |

## Frontend Integration

### Recommended Stack

- **Framework**: Next.js with TypeScript
- **Web3 Library**: Wagmi + Viem
- **Wallet Connection**: RainbowKit or ConnectKit
- **State Management**: Zustand or React Context

### Contract Integration Example
```javascript
import { useContractWrite, useContractRead } from 'wagmi'
import { ReputationRegistryABI } from './abis/ReputationRegistry'

// Read reputation score
const { data: reputationScore } = useContractRead({
  address: REPUTATION_REGISTRY_ADDRESS,
  abi: ReputationRegistryABI,
  functionName: 'getReputationScore',
  args: [userAddress],
})

// Submit rating
const { write: submitRating } = useContractWrite({
  address: RATING_SYSTEM_ADDRESS,
  abi: RatingSystemABI,
  functionName: 'submitRating',
})
```

## Deployment Addresses

### Testnet Deployments
#### Sepolia
- ReputationRegistry: `0x...`
- RatingSystem: `0x...`
- UserProfile: `0x...`
- DisputeResolution: `0x...`

#### Goerli
- ReputationRegistry: `0x...`
- RatingSystem: `0x...`
- UserProfile: `0x...`
- DisputeResolution: `0x...`

### Mainnet Deployments

*Coming soon...*

## API Reference

### Events

All contracts emit events for off-chain tracking and frontend updates. See individual contract documentation for complete event specifications.

### Error Codes

Common error codes across contracts:
- `UnauthorizedAccess()`: Caller lacks required permissions
- `InvalidRating()`: Rating value out of bounds
- `CooldownPeriodActive()`: Must wait before rating again
- `UserNotRegistered()`: User must register before participating
- `DisputeNotFound()`: Referenced dispute doesn't exist

## Contributing

### Development Workflow

1. Fork the repository
2. Create a feature branch
3. Write tests for new functionality
4. Implement the feature
5. Run full test suite
6. Submit pull request

### Code Style

- Follow Solidity style guide
- Use NatSpec documentation
- Include comprehensive tests
- Optimize for gas efficiency
