//SPDX-License-Identifier: UNLICENSED
//Copyright (C) 2022 y0rgos - All Rights Reserved

pragma solidity 0.8.17;

import "./PriceConsumerV3.sol";
import "./BalanceManager.sol";

contract Slot is BalanceManager, PriceConsumerV3 {
    uint8[36] public reel;
    uint256 randNonce = 0;
    mapping(uint8 => uint256[2]) payouts;

    constructor(address priceFeedAddress) PriceConsumerV3(priceFeedAddress) {
        // The symbols on each reel and the number of occurrence
        // (layout : [symbol, occurrence])
        uint8[2][8] memory symbols = [
            [0, 8],
            [1, 7],
            [2, 6],
            [3, 5],
            [4, 4],
            [5, 3],
            [6, 2],
            [7, 1]
        ];

        // Multiplier payouts of each combination, first place is x2, second place is x3
        // (Multipliers are multiplied by ten as of solidity does not support floating point numbers,
        //  division by ten is done after the payout calculation)
        payouts[0] = [2, 25];
        payouts[1] = [5, 45];
        payouts[2] = [10, 100];
        payouts[3] = [15, 250];
        payouts[4] = [25, 550];
        payouts[5] = [45, 1650];
        payouts[6] = [150, 6550];
        payouts[7] = [1150, 10e4];

        // Populate the reels with symbols with their corresponding number of occurrence
        // (this slot has 3 same reels so we use only 1 reel)
        uint8 counter = 0;
        for (uint8 symbol = 0; symbol < symbols.length; symbol++) {
            for (uint8 occur = 0; occur < symbols[symbol][1]; occur++) {
                reel[counter] = symbols[symbol][0];
                counter++;
            }
        }
    }

    receive() external payable {}

    // Spin the slot
    function spin(uint256 bet, uint256 spins)
        public
        payable
        returns (uint256[] memory, uint256)
    {
        /* bet = USD value * Ether Unit (Example: 0.2 * 1e18 = 2e17 (or 200000000000000000))
        Example: bet = 2e17, spins = 50 =>
        2e17 * 50 = 1e19 =>
        msg.value must be 1e19 or greater
        (1e19 = 10 USD in ether unit)
        */
        uint256 price = uint256(getLatestPrice());
        require(spins >= 1 && spins <= 100);
        require(bet >= 0.1 ether && bet <= 1 ether);
        uint256 spinsValue = bet * spins;
        uint256 sentValue = (msg.value * price) / 1e8;
        require(sentValue >= spinsValue);

        // Get 3 random results
        uint8[3] memory result = [
            reel[randMod(36)],
            reel[randMod(36)],
            reel[randMod(36)]
        ];

        uint256 payout = 0;

        // Checks if the symbols on reel 1 and 2 are the same
        if (result[0] == result[1]) {
            // "pos" indicates on which position is the multiplier on "payouts" array
            uint8 pos = 0;
            // Checks if the symbols on reel 2 and 3 are the same and update pos to the corresponding position
            if (result[1] == result[2]) pos = 1;
            payout = (msg.value * payouts[result[0]][pos]) / 10;
            updateBalance(msg.sender, payout);
        }

        return (result, payout);
    }

    // Temporary pseudorandom function
    // TODO: Replace it with Chainlink VRF
    function randMod(uint256 modulus) internal returns (uint8) {
        randNonce++;
        return
            uint8(
                uint256(
                    keccak256(
                        abi.encodePacked(block.timestamp, msg.sender, randNonce)
                    )
                ) % modulus
            );
    }
}
