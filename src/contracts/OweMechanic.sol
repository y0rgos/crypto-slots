//SPDX-License-Identifier: UNLICENSED
//Copyright (C) 2022 y0rgos - All Rights Reserved

pragma solidity 0.8.17;

import "./Math.sol";

contract OweMechanic {

    uint waitTime = 1 hours;

    mapping(address => uint256) public oweToAddress;
    mapping(address => uint256) public lastTimeUsed;

    function oweTo(address who, uint256 amount) internal {
        oweToAddress[who] += amount;
    }

    function getOwedMoney() external {
        require(oweToAddress[msg.sender] > 0, "Slot owes you nothing");
        require(block.timestamp >= lastTimeUsed[msg.sender] + waitTime, "You must wait some time");
        require(address(this).balance > 0, "Slot cannot pay you right now");

        uint256 amount = min(address(this).balance, oweToAddress[msg.sender]);
        lastTimeUsed[msg.sender] = block.timestamp;
        oweToAddress[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }
}
