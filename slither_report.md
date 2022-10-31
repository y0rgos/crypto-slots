Summary
 - [weak-prng](#weak-prng) (1 results) (High)
 - [solc-version](#solc-version) (2 results) (Informational)
## weak-prng
Impact: High
Confidence: Medium
 - [ ] ID-0
[Slot.randMod(uint256)](src/contracts/Slot.sol#L107-L117) uses a weak PRNG: "[uint8(uint256(keccak256(bytes)(abi.encodePacked(block.timestamp,msg.sender,randNonce))) % modulus)](src/contracts/Slot.sol#L109-L116)" 

src/contracts/Slot.sol#L107-L117


## solc-version
Impact: Informational
Confidence: High
 - [ ] ID-1
solc-0.8.17 is not recommended for deployment

 - [ ] ID-2
Pragma version[0.8.17](src/contracts/Slot.sol#L3) necessitates a version too recent to be trusted. Consider deploying with 0.6.12/0.7.6/0.8.7

src/contracts/Slot.sol#L3


