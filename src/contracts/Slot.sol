//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8;

contract Slot {

    uint8[3] public global_result;
    uint randNonce = 0;
    uint8[36] public reel;

    constructor(){
        uint8[2][8] memory symbols = [[0,8],
                                     [1,7],
                                     [2,6],
                                     [3,5],
                                     [4,4],
                                     [5,3],
                                     [6,2],
                                     [7,1]];
        
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
        return result;
    }

    function randMod(uint _modulus) internal returns(uint8){
        randNonce++; 
        return uint8(uint256(keccak256(abi.encodePacked(block.timestamp,msg.sender,randNonce))) % _modulus);
    }
}
