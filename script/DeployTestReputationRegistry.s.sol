// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "../src/onchain/TestReputationRegistry.sol";

/**
 * @title DeployTestReputationRegistry
 * @dev Foundry deployment script for TestReputationRegistry
 */
contract DeployTestReputationRegistry is Script {
    function run() external returns (TestReputationRegistry) {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        vm.startBroadcast(deployerPrivateKey);

        // Deploy the contract
        TestReputationRegistry testReputation = new TestReputationRegistry();

        console.log("TestReputationRegistry deployed to:", address(testReputation));

        // Optional: Register the deployer automatically
        testReputation.registerSelf();
        console.log("Deployer registered with initial reputation:", testReputation.getReputation(vm.addr(deployerPrivateKey)));

        vm.stopBroadcast();

        return testReputation;
    }
}

/**
 * @title DeployAndSetupTestReputationRegistry
 * @dev Extended deployment script that also sets up some test data
 */
contract DeployAndSetupTestReputationRegistry is Script {
    function run() external returns (TestReputationRegistry) {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);
        
        vm.startBroadcast(deployerPrivateKey);

        // Deploy the contract
        TestReputationRegistry testReputation = new TestReputationRegistry();

        console.log("TestReputationRegistry deployed to:", address(testReputation));

        // Register deployer
        testReputation.registerSelf();
        console.log("Deployer registered:", deployer);

        // Create some mock addresses for testing (these won't have private keys)
        address[] memory mockUsers = new address[](3);
        mockUsers[0] = address(0x1111111111111111111111111111111111111111);
        mockUsers[1] = address(0x2222222222222222222222222222222222222222);
        mockUsers[2] = address(0x3333333333333333333333333333333333333333);

        // Register mock users
        testReputation.batchRegisterUsers(mockUsers);
        console.log("Mock users registered:", mockUsers.length);

        // Give some ratings to mock users
        testReputation.givePositiveRating(mockUsers[0]); // Should increase reputation
        testReputation.giveNegativeRating(mockUsers[1]); // Should decrease reputation
        testReputation.giveNeutralRating(mockUsers[2]);  // Should stay neutral

        // Log final reputations
        console.log("Mock user 1 reputation:", testReputation.getReputation(mockUsers[0]));
        console.log("Mock user 2 reputation:", testReputation.getReputation(mockUsers[1]));
        console.log("Mock user 3 reputation:", testReputation.getReputation(mockUsers[2]));
        console.log("Total users registered:", testReputation.getTotalUsers());

        vm.stopBroadcast();

        return testReputation;
    }
}

/**
 * @title QuickDeployTestReputation
 * @dev Minimal deployment script for quick testing
 */
contract QuickDeployTestReputation is Script {
    function run() external returns (address) {
        vm.startBroadcast();

        TestReputationRegistry testReputation = new TestReputationRegistry();

        console.log("Contract deployed at:", address(testReputation));
        console.log("Initial reputation value:", testReputation.INITIAL_REPUTATION());
        console.log("Max reputation value:", testReputation.MAX_REPUTATION());

        vm.stopBroadcast();

        return address(testReputation);
    }
}