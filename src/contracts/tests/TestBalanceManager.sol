//SPDX-License-Identifier: UNLICENSED
//Copyright (C) 2022 y0rgos - All Rights Reserved

pragma solidity 0.8.17;

import "../BalanceManager.sol";

contract TestBalanceManager is BalanceManager{

    receive() external payable {}

    function testUpdateBalance(address who, uint256 amount) external {
        updateBalance(who, amount);
    }

}