//SPDX-License-Identifier: UNLICENSED
//Copyright (C) 2022 y0rgos - All Rights Reserved

pragma solidity 0.8.17;

import "./Math.sol";

contract BalanceManager {

    uint mustWait = 1 hours;

    mapping(address => uint256) public addressToBalance;
    mapping(address => uint256) public lastWithdraw;

    function updateBalance(address who, uint256 amount) internal {
        addressToBalance[who] += amount;
    }

    function withdraw() external {
        require(addressToBalance[msg.sender] > 0, "Zero Balance: Caller");
        require(address(this).balance > 0, "Zero Balance: Contract");
        require(block.timestamp >= lastWithdraw[msg.sender] + mustWait, "Wait 1 Hour From Last Withdraw");

        uint256 amount = min(address(this).balance, addressToBalance[msg.sender]);
        lastWithdraw[msg.sender] = block.timestamp;
        addressToBalance[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }
}
