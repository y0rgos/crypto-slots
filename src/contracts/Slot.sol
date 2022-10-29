//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8;

contract Slot {
    uint256[5] public validBetAmounts = [
        0.2 ether,
        0.4 ether,
        0.6 ether,
        0.8 ether,
        1 ether
    ];

    uint256 randNonce = 0;
    uint8[36] public reel;
    mapping(uint8 => uint256[2]) payouts;

    constructor() {
        // The symbols on each reel (first place) and the number of occurrence (second place)
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
        // (multipliers are x*10 because solidity does not support float numbers and they get x/10 after bet*payout calculation)
        payouts[0] = [4, 27];
        payouts[1] = [6, 43];
        payouts[2] = [9, 92];
        payouts[3] = [14, 240];
        payouts[4] = [24, 540];
        payouts[5] = [46, 1660];
        payouts[6] = [170, 6250];
        payouts[7] = [1140, 100000];

        // Populate the reels with symbols with their corresponding number of occurrence
        // (this slot has 3 same reels so we use 1 reel)
        uint8 reelCounter;
        for (uint8 symbol = 0; symbol < symbols.length; symbol++) {
            for (
                uint256 symbolOccur = 0;
                symbolOccur < symbols[symbol][1];
                symbolOccur++
            ) {
                reel[reelCounter] = symbols[symbol][0];
                reelCounter++;
            }
        }
    }

    // Spin the slot
    // (not ready yet)
    function spin() public payable returns (uint8[3] memory, uint256) {
        // Check if the bet is valid
        bool validBet = false;
        for (uint256 i = 0; i < validBetAmounts.length; i++) {
            if (msg.value == validBetAmounts[i]) {
                validBet = true;
                break;
            }
        }
        require(
            validBet,
            "Bet is not valid. Valid amounts are 0.2, 0.4, 0.6, 0.8, 1.0 ether"
        );

        // Get 3 random results
        uint8[3] memory result = [
            reel[randMod(36)],
            reel[randMod(36)],
            reel[randMod(36)]
        ];

        // Check if player wins and calculate the reward
        uint256 payout;
        if (result[0] == result[1] && result[1] == result[2]) {
            payout = (msg.value * payouts[result[0]][1]) / 10;
        } else if (result[0] == result[1]) {
            payout = (msg.value * payouts[result[0]][0]) / 10;
        }

        return (result, payout);
    }

    // Temporary pseudorandom function
    function randMod(uint256 _modulus) internal returns (uint8) {
        randNonce++;
        return
            uint8(
                uint256(
                    keccak256(
                        abi.encodePacked(block.timestamp, msg.sender, randNonce)
                    )
                ) % _modulus
            );
    }
}
