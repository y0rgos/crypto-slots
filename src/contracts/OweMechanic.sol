//SPDX-License-Identifier: UNLICENSED
//Copyright (C) 2022 y0rgos - All Rights Reserved

pragma solidity 0.8.17;

import "./Math.sol";

contract OweMechanic {
    mapping(address => uint256) public oweToAddress;

    function oweTo(address who, uint256 amount) internal {
        oweToAddress[who] += amount;
    }

    function getOwedMoney() external {
        require(oweToAddress[msg.sender] > 0, "Slot owes you nothing");
        require(address(this).balance > 0, "Slot cannot pay you right now");

        uint256 amount = min(address(this).balance, oweToAddress[msg.sender]);
        oweToAddress[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }
}
