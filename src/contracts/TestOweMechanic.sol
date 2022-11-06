//SPDX-License-Identifier: UNLICENSED
//Copyright (C) 2022 y0rgos - All Rights Reserved

pragma solidity 0.8.17;

import "./BalanceManager.sol";

contract TestOweMechanic is BalanceManager{

    receive() external payable {}

    function testOweTo(address who, uint256 amount) external {
        updateBalance(who, amount);
    }

}