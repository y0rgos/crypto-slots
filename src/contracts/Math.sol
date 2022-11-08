//SPDX-License-Identifier: UNLICENSED
//Copyright (C) 2022 y0rgos - All Rights Reserved

pragma solidity 0.8.17;

library Math {
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }
}
