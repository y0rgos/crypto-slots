//SPDX-License-Identifier: UNLICENSED
//Copyright (C) 2022 y0rgos - All Rights Reserved

pragma solidity 0.8.17;

contract OweMechanic {
    mapping(address => uint256) public oweToAddress;

    // Test Function
    function oweToSomeone(address oweToWho, uint256 amount) public {
        oweToAddress[oweToWho] += amount;
    }

    function getOwedMoney() external {
        require(oweToAddress[msg.sender] > 0, "Slot owes you nothing");
        require(address(this).balance > 0, "Slot cannot pay you right now");

        uint256 amount = min(address(this).balance, oweToAddress[msg.sender]);
        oweToAddress[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }

    // Change to OpenZeppelin's math library
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a <= b ? a : b;
    }
}
