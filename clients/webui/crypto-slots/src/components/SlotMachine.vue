<template>
    <div class="container text-center p-3">
        <div class="row">

            <!-- Left Column -->
            <div class="col">
                <PayoutsTable />
                <h4>Total amount won</h4>
                <h5> Ξ{{ playerSlotBalance }} </h5>
                <h6>(≈ ${{ playerSlotBalance * ethPrice }})</h6>
                <button type="button" class="btn btn-success" :disabled="!playerSlotBalance"
                    @click="withdraw">Withdraw</button>
            </div>

            <!-- Middle Column -->
            <div class="col-6">
                <Reels :bet="bet" :symbols="symbols" :randomWords="randomWords"
                    :randomWordsCounter="randomWordsCounter" />
            </div>

            <!-- Right Column -->
            <div class="col" v-if="state == 'bidding'">
                <label for="bet" class="form-label">Bet: ${{ bet }}</label>
                <input type="range" class="form-range" v-model="bet" min="0.1" max="1" step="0.1" id="bet">

                <label for="spins" class="form-label">Spins: {{ spins }}</label>
                <input type="range" class="form-range" v-model="spins" min="1" max="100" id="spins">

                <p>Total: ${{ total }} (≈ Ξ{{ total / ethPrice }})</p>

                <button type="button" class="btn btn-primary m-2" @click="spin">Spin</button>
            </div>

            <div class="col" v-else-if="state == 'waiting'">
                <div class="spinner-border" role="status">
                    <span class="visually-hidden">Loading...</span>
                </div>
                <p>Waiting for VRF Response...</p>
            </div>

            <div class="col" v-else-if="state == 'results'">
                <button class="btn btn-primary" @click="nextResult">Next ({{ randomWordsCounter + 1 }}/{{
                        randomWords.length
                }})</button>
            </div>

        </div>
    </div>
</template>

<script>
import Web3 from 'web3'
import PayoutsTable from './PayoutsTable.vue'
import Reels from './Reels.vue'

export default {
    data() {
        return {
            bet: 0.1,
            spins: 10,
            slot: null,
            web3: null,
            ethPrice: null,
            state: 'bidding',
            randomWords: null,
            playerSlotBalance: null,
            randomWordsCounter: null,
            slotAddress: '0x6b4BDe1086912A6Cb24ce3dB43b3466e6c72AFd3',
            slotAbi: JSON.parse(`[{"inputs": [{"internalType": "address", "name": "priceFeedAddress", "type": "address"}, {"internalType": "uint64", "name": "subscriptionId", "type": "uint64"}, {"internalType": "address", "name": "vrfCoordinatorAddress", "type": "address"}], "stateMutability": "nonpayable", "type": "constructor", "name": "constructor"}, {"inputs": [{"internalType": "address", "name": "have", "type": "address"}, {"internalType": "address", "name": "want", "type": "address"}], "name": "OnlyCoordinatorCanFulfill", "type": "error"}, {"anonymous": false, "inputs": [{"indexed": true, "internalType": "address", "name": "from", "type": "address"}, {"indexed": true, "internalType": "address", "name": "to", "type": "address"}], "name": "OwnershipTransferRequested", "type": "event"}, {"anonymous": false, "inputs": [{"indexed": true, "internalType": "address", "name": "from", "type": "address"}, {"indexed": true, "internalType": "address", "name": "to", "type": "address"}], "name": "OwnershipTransferred", "type": "event"}, {"anonymous": false, "inputs": [{"indexed": false, "internalType": "uint256", "name": "requestId", "type": "uint256"}, {"indexed": false, "internalType": "uint256[]", "name": "randomWords", "type": "uint256[]"}], "name": "RequestFulfilled", "type": "event"}, {"anonymous": false, "inputs": [{"indexed": false, "internalType": "uint256", "name": "requestId", "type": "uint256"}, {"indexed": false, "internalType": "uint32", "name": "numWords", "type": "uint32"}], "name": "RequestSent", "type": "event"}, {"inputs": [], "name": "acceptOwnership", "outputs": [], "stateMutability": "nonpayable", "type": "function"}, {"inputs": [{"internalType": "address", "name": "", "type": "address"}], "name": "addressToBalance", "outputs": [{"internalType": "uint256", "name": "", "type": "uint256"}], "stateMutability": "view", "type": "function"}, {"inputs": [], "name": "getLatestPrice", "outputs": [{"internalType": "int256", "name": "", "type": "int256"}], "stateMutability": "view", "type": "function"}, {"inputs": [{"internalType": "uint256", "name": "_requestId", "type": "uint256"}], "name": "getRequestStatus", "outputs": [{"internalType": "bool", "name": "fulfilled", "type": "bool"}, {"internalType": "uint256[]", "name": "randomWords", "type": "uint256[]"}], "stateMutability": "view", "type": "function"}, {"inputs": [], "name": "lastRequestId", "outputs": [{"internalType": "uint256", "name": "", "type": "uint256"}], "stateMutability": "view", "type": "function"}, {"inputs": [{"internalType": "address", "name": "", "type": "address"}], "name": "lastWithdraw", "outputs": [{"internalType": "uint256", "name": "", "type": "uint256"}], "stateMutability": "view", "type": "function"}, {"inputs": [], "name": "owner", "outputs": [{"internalType": "address", "name": "", "type": "address"}], "stateMutability": "view", "type": "function"}, {"inputs": [{"internalType": "uint256", "name": "requestId", "type": "uint256"}, {"internalType": "uint256[]", "name": "randomWords", "type": "uint256[]"}], "name": "rawFulfillRandomWords", "outputs": [], "stateMutability": "nonpayable", "type": "function"}, {"inputs": [{"internalType": "uint256", "name": "", "type": "uint256"}], "name": "reel", "outputs": [{"internalType": "uint8", "name": "", "type": "uint8"}], "stateMutability": "view", "type": "function"}, {"inputs": [{"internalType": "uint256", "name": "", "type": "uint256"}], "name": "requestIds", "outputs": [{"internalType": "uint256", "name": "", "type": "uint256"}], "stateMutability": "view", "type": "function"}, {"inputs": [{"internalType": "uint256", "name": "", "type": "uint256"}], "name": "s_requests", "outputs": [{"internalType": "bool", "name": "fulfilled", "type": "bool"}, {"internalType": "bool", "name": "exists", "type": "bool"}, {"internalType": "address", "name": "from", "type": "address"}, {"internalType": "uint256", "name": "bet", "type": "uint256"}], "stateMutability": "view", "type": "function"}, {"inputs": [{"internalType": "uint256", "name": "bet", "type": "uint256"}, {"internalType": "uint32", "name": "spins", "type": "uint32"}], "name": "spin", "outputs": [], "stateMutability": "payable", "type": "function"}, {"inputs": [{"internalType": "address", "name": "to", "type": "address"}], "name": "transferOwnership", "outputs": [], "stateMutability": "nonpayable", "type": "function"}, {"inputs": [{"internalType": "address", "name": "", "type": "address"}], "name": "waitingForResponse", "outputs": [{"internalType": "bool", "name": "", "type": "bool"}], "stateMutability": "view", "type": "function"}, {"inputs": [], "name": "withdraw", "outputs": [], "stateMutability": "nonpayable", "type": "function"}, {"stateMutability": "payable", "type": "receive"}]`),
            symbols: {
                0: {
                    'symbol': '🍋',
                    'payout': [0.2, 2.5]
                },
                1: {
                    'symbol': '🍇',
                    'payout': [0.5, 4.5]
                },
                2: {
                    'symbol': '🍉',
                    'payout': [1.0, 10.0]
                },
                3: {
                    'symbol': '🍓',
                    'payout': [1.5, 25.0]
                },
                4: {
                    'symbol': '🍒',
                    'payout': [2.5, 55.0]
                },
                5: {
                    'symbol': '🌶️',
                    'payout': [4.5, 165.0]
                },
                6: {
                    'symbol': '🍌',
                    'payout': [15.0, 655.0]
                },
                7: {
                    'symbol': '🍄',
                    'payout': [115.0, 10000.0]
                },
            }
        }
    },

    props: ['ethereum'],

    components: {
        PayoutsTable,
        Reels
    },

    async created() {
        this.web3 = new Web3(this.ethereum)
        this.slot = new this.web3.eth.Contract(this.slotAbi, this.slotAddress)
        this.updateEthPrice()
        this.updatePlayerSlotBalance()
        this.listenForEvents()
    },

    computed: {
        total() {
            return this.bet * this.spins
        }
    },

    methods: {
        withdraw() {
            this.updateEthPrice()
            this.slot.methods.withdraw().send({ from: this.ethereum.selectedAddress })
            this.updatePlayerSlotBalance()

        },
        spin() {
            this.updateEthPrice()
            this.slot.methods.spin(this.web3.utils.toWei(String(this.bet), 'ether'), this.spins).send(
                {
                    from: this.ethereum.selectedAddress,
                    value: this.web3.utils.toWei(String((this.bet * this.spins) / this.ethPrice), 'ether'),
                }).then(() => {
                    this.state = 'waiting'
                })
        },
        nextResult() {
            this.randomWordsCounter += 1
            if (this.randomWordsCounter == this.randomWords.length) {
                this.state = 'bidding'
                this.updatePlayerSlotBalance()
            }
        },
        listenForEvents() {
            this.slot.events.RequestSent().on('data', async event => {
                let reqId = event['returnValues']['requestId']
                let data = await this.slot.methods.s_requests(reqId).call()
                if (data.from.toLowerCase() == this.ethereum.selectedAddress.toLowerCase()) {
                    this.requestId = reqId
                }
            })

            this.slot.events.RequestFulfilled().on('data', event => {
                let ret = event['returnValues']
                if (this.requestId == ret['requestId']) {
                    this.randomWords = ret['randomWords']
                    this.randomWordsCounter = 0
                    this.state = 'results'
                }
            })
        },
        async updateEthPrice() {
            this.ethPrice = await this.slot.methods.getLatestPrice().call() / 1e8
        },
        async updatePlayerSlotBalance() {
            this.playerSlotBalance = await this.slot.methods.addressToBalance(this.ethereum.selectedAddress).call() / 1e18
        },
    }

}
</script>