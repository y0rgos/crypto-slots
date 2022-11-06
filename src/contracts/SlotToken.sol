//SPDX-License-Identifier: UNLICENSED
//Copyright (C) 2022 y0rgos - All Rights Reserved

pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "./PriceConsumerV3.sol";
import "./BalanceManager.sol";

// Smart Contract Is Not Ready
contract SlotToken is ERC20, ERC20Burnable, PriceConsumerV3, BalanceManager {
    constructor(address priceFeedAddress)
        ERC20("SlotToken", "SLTKN")
        PriceConsumerV3(priceFeedAddress)
    {}

    function buyTokens() public payable {
        uint256 price = uint256(getLatestPrice());
        require((msg.value * price) / 1e8 >= 10 ether, "Min 10 USD");
        _mint(msg.sender, ((msg.value * price) / 1e6));
    }

    function sellTokens(uint256 amount) public {
        burn(amount);
        uint256 price = uint256(getLatestPrice());
        updateBalance(msg.sender, ((amount * 1e6) / price));
    }
}
