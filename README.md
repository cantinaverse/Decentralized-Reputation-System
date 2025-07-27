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
