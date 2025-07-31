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
