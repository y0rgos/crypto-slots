//SPDX-License-Identifier: UNLICENSED
//Copyright (C) 2022 y0rgos - All Rights Reserved

pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "./PriceConsumerV3.sol";

// Smart Contract Is Not Ready
contract SlotToken is ERC20, ERC20Burnable, PriceConsumerV3 {
    constructor(address priceFeedAddress)
        ERC20("SlotToken", "SLTKN")
        PriceConsumerV3(priceFeedAddress)
    {}

    function buy() public payable {
        uint256 price = uint256(getLatestPrice()) / 1e8;
        require(msg.value * price >= 10 ether, "Min 10 USD");
        _mint(msg.sender, (msg.value * price) * 100);
    }

    function sell(uint256 amount) public {
        require(balanceOf(msg.sender) >= amount);
        burn(amount);
    }
}
