//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8;

contract Slot {

    mapping(uint8 => uint[2]) payouts;
    uint8[36] public reel;
    uint256[5] public validBetAmounts = [
        0.2 ether,
        0.4 ether,
        0.6 ether,
        0.8 ether,
        1 ether
    ];

    mapping(address => uint) public oweToAddress;

    uint256 randNonce = 0;

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

        // ~= 95% RTP
        payouts[0] = [2, 25];
        payouts[1] = [5, 45];
        payouts[2] = [10, 100];
        payouts[3] = [25, 250];
        payouts[4] = [25, 550];
        payouts[5] = [45, 1650];
        payouts[6] = [150, 6550];
        payouts[7] = [1150, 100000];

        // Populate the reels with symbols with their corresponding number of occurrence
        // (this slot has 3 same reels so we use 1 reel)
        uint8 reelCounter;
        for (uint8 symbol = 0; symbol < symbols.length; symbol++) {
            for (
                uint8 symbolOccur = 0;
                symbolOccur < symbols[symbol][1];
                symbolOccur++
            ) {
                reel[reelCounter] = symbols[symbol][0];
                reelCounter++;
            }
        }
    }

    receive() external payable {}


    // Spin the slot
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

        if (payout > 0) {
            if (int(address(this).balance) - int(payout) >= 0){
                payable(msg.sender).transfer(payout);
            } else {
                oweToAddress[msg.sender] += payout;
            }
        }

        return (result, payout);
    }

    function getOwedMoney() external {
        require(oweToAddress[msg.sender] > 0, "Slot owes you nothing");
        require(address(this).balance > 0, "Slot cannot pay you right now");

        if (int(address(this).balance) - int(oweToAddress[msg.sender]) >= 0){
            payable(msg.sender).transfer(oweToAddress[msg.sender]);
            oweToAddress[msg.sender] = 0;
        } else {
            uint canAfford = oweToAddress[msg.sender] - address(this).balance;
            payable(msg.sender).transfer(canAfford);
            oweToAddress[msg.sender] -= canAfford;
        }
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
