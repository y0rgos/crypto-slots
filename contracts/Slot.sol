//SPDX-License-Identifier: UNLICENSED
//Copyright (C) 2022 y0rgos - All Rights Reserved

pragma solidity 0.8.17;

import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "@chainlink/contracts/src/v0.8/ConfirmedOwner.sol";

import "./BalanceManager.sol";

contract Slot is BalanceManager, VRFConsumerBaseV2, ConfirmedOwner {
    //////////////////////////////////////// VRF //////////////////////////////////////
    event RequestSent(uint256 requestId, uint32 numWords);
    event RequestFulfilled(uint256 requestId, uint256[] randomWords);

    struct RequestStatus {
        bool fulfilled; // whether the request has been successfully fulfilled
        bool exists; // whether a requestId exists
        uint256[] randomWords;
        address from;
        uint256 bet;
    }
    mapping(uint256 => RequestStatus) public s_requests; /* requestId --> requestStatus */
    mapping(address => bool) public waitingForResponse;
    VRFCoordinatorV2Interface COORDINATOR;

    // Your subscription ID.
    uint64 s_subscriptionId;

    // past requests Id.
    uint256[] public requestIds;
    uint256 public lastRequestId;

    bytes32 keyHash =
        0x79d3d8832d904592c0bf9818b621522c988bb8b0c05cdc3b15aea1b6e8db0c15;

    uint32 callbackGasLimit = 3000000;

    uint16 requestConfirmations = 3;

    ///////////////////////////////////  Price Feed ///////////////////////////////////
    AggregatorV3Interface internal priceFeed;
    ///////////////////////////////////////////////////////////////////////////////////////


    uint8[36] public reel;
    mapping(uint256 => uint256[2]) payouts;

    constructor(
        address priceFeedAddress,
        uint64 subscriptionId,
        address vrfCoordinatorAddress
    ) VRFConsumerBaseV2(vrfCoordinatorAddress) ConfirmedOwner(msg.sender) {
        priceFeed = AggregatorV3Interface(priceFeedAddress);
        COORDINATOR = VRFCoordinatorV2Interface(vrfCoordinatorAddress);
        s_subscriptionId = subscriptionId;

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
    function spin(uint256 bet, uint32 spins)
        public
        payable
    {
        /* bet = USD value * Ether Unit (Example: 0.2 * 1e18 = 2e17 (or 200000000000000000))
        Example: bet = 2e17, spins = 50 =>
        2e17 * 50 = 1e19 =>
        msg.value must be 1e19 or greater
        (1e19 = 10 USD in ether unit)
        */
        require(!waitingForResponse[msg.sender], "Waiting For Response");
        uint256 price = uint256(getLatestPrice());
        require(spins >= 1 && spins <= 100, "1 <= Spins <= 100");
        require(bet >= 0.1 ether && bet <= 1 ether, "$0.10 <= Bet <= $1.0");
        uint256 spinsValue = bet * spins;
        uint256 sentValue = (msg.value * price) / 1e8;
        require(sentValue >= spinsValue, "Insufficient Funds");

        waitingForResponse[msg.sender] = true;
        requestRandomWords(bet, spins);
    }

    function getLatestPrice() public view returns (int256) {
        (, int256 price, , , ) = priceFeed.latestRoundData();
        return price;
    }

    // Assumes the subscription is funded sufficiently.
    function requestRandomWords(uint256 bet, uint32 numWords)
        private
        returns (uint256 requestId)
    {
        // Will revert if subscription is not set and funded.
        requestId = COORDINATOR.requestRandomWords(
            keyHash,
            s_subscriptionId,
            requestConfirmations,
            callbackGasLimit,
            numWords
        );
        s_requests[requestId] = RequestStatus({
            randomWords: new uint256[](0),
            exists: true,
            fulfilled: false,
            from: msg.sender,
            bet: bet
        });
        requestIds.push(requestId);
        lastRequestId = requestId;
        emit RequestSent(requestId, numWords);
        return requestId;
    }

    function fulfillRandomWords(
        uint256 _requestId,
        uint256[] memory _randomWords
    ) internal override {
        require(s_requests[_requestId].exists, "request not found");
        s_requests[_requestId].fulfilled = true;
        s_requests[_requestId].randomWords = _randomWords;
        calculatePayout(s_requests[_requestId].bet, s_requests[_requestId].from, _randomWords);
        waitingForResponse[s_requests[_requestId].from] = false;
        emit RequestFulfilled(_requestId, _randomWords);
    }

    function getRequestStatus(uint256 _requestId)
        external
        view
        returns (bool fulfilled, uint256[] memory randomWords)
    {
        require(s_requests[_requestId].exists, "request not found");
        RequestStatus memory request = s_requests[_requestId];
        return (request.fulfilled, request.randomWords);
    }

    function calculatePayout(uint256 bet, address from, uint256[] memory randomWords) private {
        for(uint8 i = 0; i < randomWords.length; i ++) {
            uint256 r1 = reel[(randomWords[i] % 100) % 36];
            uint256 r2 = reel[((randomWords[i] % 10000) / 100) % 36];
            uint256 r3 = reel[((randomWords[i] % 1000000) / 10000) % 36];

            uint256 payout = 0;

            // Checks if the symbols on reel 1 and 2 are the same
            if (r1 == r2) {
                // "pos" indicates on which position is the multiplier on "payouts" array
                uint8 pos = 0;
                // Checks if the symbols on reel 2 and 3 are the same and update pos to the corresponding position
                if (r2 == r3) pos = 1;
                payout = (((bet * payouts[r1][pos]) / 10) * 1e8) / uint256(getLatestPrice());
                updateBalance(from, payout);
            }
        }
    }
}