//SPDX-License-Identifier: UNLICENSED
//Copyright (C) 2022 y0rgos - All Rights Reserved

pragma solidity 0.8.17;

import "./OweMechanic.sol";

contract TestOweMechanic is OweMechanic{

    receive() external payable {}

    function testOweTo(address who, uint256 amount) external {
        oweTo(who, amount);
    }

}