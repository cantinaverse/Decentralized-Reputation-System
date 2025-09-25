// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title TestReputationRegistry
 * @dev Simplified version of ReputationRegistry for testnet testing
 * @notice Removes restrictions to allow easy testing with multiple wallets
 */
contract TestReputationRegistry {
    // Constants for reputation calculations
    uint256 public constant MAX_REPUTATION = 1000;
    uint256 public constant MIN_REPUTATION = 0;
    uint256 public constant INITIAL_REPUTATION = 500;
    string private info = "Version 0.0.5";

    // Simplified struct
    struct ReputationData {
        uint256 score;
        uint256 totalRatings;
        bool isRegistered;
    }

    // State variables
    mapping(address => ReputationData) private _reputations;
    address[] private _registeredUsers;

    // Events
    event UserRegistered(address indexed user, uint256 initialReputation);
    event ReputationUpdated(address indexed user, uint256 oldScore, uint256 newScore, address indexed rater);

    constructor() {
    }

    /**
     * @dev Register a new user (anyone can call)
     * @param user Address of the user to register
     */
    function registerUser(address user) public {
        // Allow re-registration for testing
        if (!_reputations[user].isRegistered) {
            _registeredUsers.push(user);
        }

        _reputations[user] = ReputationData({score: INITIAL_REPUTATION, totalRatings: 0, isRegistered: true});

        emit UserRegistered(user, INITIAL_REPUTATION);
    }

    /**
     * @dev Register yourself
     */
    function registerSelf() public {
        registerUser(msg.sender);
    }

    /**
     * @dev Update a user's reputation (anyone can call, including self-rating)
     * @param user Address of the user being rated
     * @param rating New rating score (0-1000)
     */
    function updateReputation(address user, uint256 rating) public {
        // Auto-register if not registered
        if (!_reputations[user].isRegistered) {
            registerUser(user);
        }

        // Auto-register rater if not registered
        if (!_reputations[msg.sender].isRegistered) {
            registerUser(msg.sender);
        }

        // Clamp rating to valid range
        if (rating > MAX_REPUTATION) {
            rating = MAX_REPUTATION;
        }

        ReputationData storage userData = _reputations[user];
        uint256 oldScore = userData.score;

        // Simple average calculation
        userData.totalRatings += 1;
        userData.score = ((userData.score * (userData.totalRatings - 1)) + rating) / userData.totalRatings;

        emit ReputationUpdated(user, oldScore, userData.score, msg.sender);
    }

    /**
     * @dev Give a positive rating (800 points)
     * @param user Address of the user being rated
     */
    function givePositiveRating(address user) external {
        updateReputation(user, 800);
    }

    /**
     * @dev Give a negative rating (200 points)
     * @param user Address of the user being rated
     */
    function giveNegativeRating(address user) external {
        updateReputation(user, 200);
    }

    /**
     * @dev Give a neutral rating (500 points)
     * @param user Address of the user being rated
     */
    function giveNeutralRating(address user) external {
        updateReputation(user, 500);
    }

    /**
     * @dev Set reputation directly for testing
     * @param user Address of the user
     * @param score New reputation score
     */
    function setReputation(address user, uint256 score) external {
        if (!_reputations[user].isRegistered) {
            registerUser(user);
        }

        if (score > MAX_REPUTATION) {
            score = MAX_REPUTATION;
        }

        uint256 oldScore = _reputations[user].score;
        _reputations[user].score = score;

        emit ReputationUpdated(user, oldScore, score, msg.sender);
    }

    /**
     * @dev Get a user's current reputation score
     * @param user Address of the user
     * @return Current reputation score
     */
    function getReputation(address user) external view returns (uint256) {
        if (!_reputations[user].isRegistered) {
            return INITIAL_REPUTATION; // Return default instead of reverting
        }
        return _reputations[user].score;
    }

    /**
     * @dev Get detailed reputation data for a user
     * @param user Address of the user
     * @return ReputationData struct with all reputation information
     */
    function getReputationData(address user) external view returns (ReputationData memory) {
        if (!_reputations[user].isRegistered) {
            return ReputationData({score: INITIAL_REPUTATION, totalRatings: 0, isRegistered: false});
        }
        return _reputations[user];
    }

    /**
     * @dev Check if user is registered
     * @param user Address of the user
     * @return Whether user is registered
     */
    function isRegistered(address user) external view returns (bool) {
        return _reputations[user].isRegistered;
    }

    /**
     * @dev Get all registered users
     * @return users Array of user addresses
     */
    function getAllRegisteredUsers() external view returns (address[] memory) {
        return _registeredUsers;
    }

    /**
     * @dev Get total number of registered users
     * @return Total user count
     */
    function getTotalUsers() external view returns (uint256) {
        return _registeredUsers.length;
    }

    /**
     * @dev Batch register multiple users
     * @param users Array of user addresses to register
     */
    function batchRegisterUsers(address[] calldata users) external {
        for (uint256 i = 0; i < users.length; i++) {
            registerUser(users[i]);
        }
    }

    /**
     * @dev Get reputation scores for multiple users
     * @param users Array of user addresses
     * @return scores Array of reputation scores
     */
    function getBatchReputations(address[] calldata users) external view returns (uint256[] memory scores) {
        scores = new uint256[](users.length);
        for (uint256 i = 0; i < users.length; i++) {
            scores[i] = _reputations[users[i]].isRegistered ? _reputations[users[i]].score : INITIAL_REPUTATION;
        }
    }

    /**
     * @dev Reset a user's reputation to initial value
     * @param user Address of the user
     */
    function resetReputation(address user) external {
        if (!_reputations[user].isRegistered) {
            registerUser(user);
        } else {
            uint256 oldScore = _reputations[user].score;
            _reputations[user].score = INITIAL_REPUTATION;
            _reputations[user].totalRatings = 0;

            emit ReputationUpdated(user, oldScore, INITIAL_REPUTATION, msg.sender);
        }
    }
}
