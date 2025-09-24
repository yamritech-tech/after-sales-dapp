// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

/// @title Lock Contract
/// @notice Allows the owner to lock funds until a specified unlock time.
/// @dev This contract holds ETH until the unlock time has passed, then allows the owner to withdraw.
contract Lock {
    /// @notice The timestamp when funds can be withdrawn.
    uint256 public unlockTime;

    /// @notice The owner of the contract (who can withdraw the funds).
    address payable public owner;

    /// @notice Emitted when a withdrawal is made.
    /// @param amount The amount withdrawn.
    /// @param when The timestamp of withdrawal.
    event Withdrawal(uint256 amount, uint256 when);

    /// @notice Deploys the contract with a future unlock time and initial deposit.
    /// @param _unlockTime The timestamp when funds can be withdrawn.
    constructor(uint256 _unlockTime) payable {
        require(
            block.timestamp < _unlockTime,
            "Unlock time must be in the future"
        );

        unlockTime = _unlockTime;
        owner = payable(msg.sender);
    }

    /// @notice Withdraws the contract balance if unlock time has passed.
    /// @dev Only the owner can call this function.
    function withdraw() external {
        require(block.timestamp >= unlockTime, "You cannot withdraw yet");
        require(msg.sender == owner, "Only the owner can withdraw");

        uint256 balance = address(this).balance;

        emit Withdrawal(balance, block.timestamp);

        owner.transfer(balance);
    }
}
