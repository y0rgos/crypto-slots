//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8;

contract Slot {

    uint8[3] public global_result;
    uint public global_payout;

    uint randNonce = 0;
    uint8[36] public reel;
    mapping(uint8=>uint256[2]) payouts;

    constructor(){
        uint8[2][8] memory symbols = [[0,8],
                                     [1,7],
                                     [2,6],
                                     [3,5],
                                     [4,4],
                                     [5,3],
                                     [6,2],
                                     [7,1]];

        payouts[0] = [4 , 27];
        payouts[1] = [6 , 43];
        payouts[2] = [9 , 92];
        payouts[3] = [14 , 240];
        payouts[4] = [24 , 540];
        payouts[5] = [46 , 1660];
        payouts[6] = [170  , 6250];
        payouts[7] = [1140 , 100000];
        
        uint8 reel_counter;
        for (uint8 symbol = 0; symbol < symbols.length; symbol++){
            for (uint symbol_occur = 0; symbol_occur < symbols[symbol][1]; symbol_occur++){
                reel[reel_counter] = symbols[symbol][0];
                reel_counter ++;
            } 
        }
    }

    function spin() public returns(uint8[3] memory) {
        uint8[3] memory result = [reel[randMod(36)], reel[randMod(36)], reel[randMod(36)]];
        global_result = result;
        if (result[0] == result[1] && result[1] == result[2]){
            global_payout = (1 ether * payouts[result[0]][1]) / 10;
        } else if (result[0] == result[1]){
            global_payout = (1 ether * payouts[result[0]][0]) / 10;
        } else {
            global_payout = 0;
        }
        return result;
    }

    function randMod(uint _modulus) internal returns(uint8){
        randNonce++; 
        return uint8(uint256(keccak256(abi.encodePacked(block.timestamp,msg.sender,randNonce))) % _modulus);
    }
}
