<template>
  <div>
    <button v-if="!connected" @click="connect">Connect wallet</button>

    <table v-if="showPayouts">
      <tr>
        <th>Number</th>
        <th>Symbols</th>
        <th>2 Symbols</th>
        <th>3 Symbols</th>
      </tr>
      <tr v-for="(value, key, index) in symbols">
        <td>{{ key }}</td>
        <td>{{ value }}</td>
        <td>x{{ payouts[key][0] }}</td>
        <td>x{{ payouts[key][1] }}</td>
      </tr>
    </table>

    <button @click="showPayouts = !showPayouts">Show/Hide Payouts</button>

    <div v-if="connected && !waitingForRespone">
      <p>Total Amount Won: ${{ playerSlotBalance * ethPrice }} ({{ playerSlotBalance }} ETH)<button
          v-if="playerSlotBalance" @click="withdraw">Withdraw</button></p>
      <p>Bet : <input type="range" v-model="bet" min="0.1" max="1" step="0.1" /> ${{ bet }}</p>
      <p>Spins : <input type="range" min="1" max="100" v-model="spins" /> {{ spins }}</p>
      <p>Total: ${{ bet * spins }} ({{ (bet * spins) / ethPrice }} ETH)</p>
      <button @click="spin">Spin</button>
    </div>

    <p>{{ message }}</p>

    <div v-if="slotsRunning">
      <h1>|{{ reel1 }}|{{ reel2 }}|{{ reel3 }}|</h1>
      <p v-if="won">WIN: ${{ won }} 💵</p>
      <p>{{ randomWordsCounter + 1 }} out of {{ randomWords.length }} <button @click="nextSlot">Next</button></p>
    </div>

  </div>
</template>

<script>
import Web3 from 'web3'


export default {
  name: 'App',

  data() {
    return {
      won: 0,
      bet: 0.10,
      spins: 10,
      web3: null,
      slot: null,
      reel1: null,
      reel2: null,
      reel3: null,
      requestId: 0,
      message: null,
      ethPrice: null,
      connected: false,
      randomWords: null,
      showPayouts: false,
      slotsRunning: false,
      playerSlotBalance: 0,
      waitingForRespone: false,
      randomWordsCounter: null,
      total: this.bet * this.spins,
      reel: [0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 6, 6, 7],
      symbols: { 0: '🍋', 1: '🍇', 2: '🍉', 3: '🍓', 4: '🍒', 5: '🌶️', 6: '🍌', 7: '🍄' },
      payouts: { 0: [0.2, 2.5], 1: [0.5, 4.5], 2: [1.0, 10.0], 3: [1.5, 25.0], 4: [2.5, 55.0], 5: [4.5, 165.0], 6: [15.0, 655.0], 7: [115.0, 10000.0] },
    }
  },

  methods: {
    connect() {
      let ethereum = window.ethereum;
      if (ethereum) {
        ethereum.request({ method: 'eth_requestAccounts' })
          .then(() => {
            this.connected = true;
            this.web3 = new Web3(ethereum)
            this.instantiateSlot()
          });
      }
    },

    async instantiateSlot() {
      let slotAddress = '0x6b4BDe1086912A6Cb24ce3dB43b3466e6c72AFd3';
      let abi = JSON.parse(`[{"inputs": [{"internalType": "address", "name": "priceFeedAddress", "type": "address"}, {"internalType": "uint64", "name": "subscriptionId", "type": "uint64"}, {"internalType": "address", "name": "vrfCoordinatorAddress", "type": "address"}], "stateMutability": "nonpayable", "type": "constructor", "name": "constructor"}, {"inputs": [{"internalType": "address", "name": "have", "type": "address"}, {"internalType": "address", "name": "want", "type": "address"}], "name": "OnlyCoordinatorCanFulfill", "type": "error"}, {"anonymous": false, "inputs": [{"indexed": true, "internalType": "address", "name": "from", "type": "address"}, {"indexed": true, "internalType": "address", "name": "to", "type": "address"}], "name": "OwnershipTransferRequested", "type": "event"}, {"anonymous": false, "inputs": [{"indexed": true, "internalType": "address", "name": "from", "type": "address"}, {"indexed": true, "internalType": "address", "name": "to", "type": "address"}], "name": "OwnershipTransferred", "type": "event"}, {"anonymous": false, "inputs": [{"indexed": false, "internalType": "uint256", "name": "requestId", "type": "uint256"}, {"indexed": false, "internalType": "uint256[]", "name": "randomWords", "type": "uint256[]"}], "name": "RequestFulfilled", "type": "event"}, {"anonymous": false, "inputs": [{"indexed": false, "internalType": "uint256", "name": "requestId", "type": "uint256"}, {"indexed": false, "internalType": "uint32", "name": "numWords", "type": "uint32"}], "name": "RequestSent", "type": "event"}, {"inputs": [], "name": "acceptOwnership", "outputs": [], "stateMutability": "nonpayable", "type": "function"}, {"inputs": [{"internalType": "address", "name": "", "type": "address"}], "name": "addressToBalance", "outputs": [{"internalType": "uint256", "name": "", "type": "uint256"}], "stateMutability": "view", "type": "function"}, {"inputs": [], "name": "getLatestPrice", "outputs": [{"internalType": "int256", "name": "", "type": "int256"}], "stateMutability": "view", "type": "function"}, {"inputs": [{"internalType": "uint256", "name": "_requestId", "type": "uint256"}], "name": "getRequestStatus", "outputs": [{"internalType": "bool", "name": "fulfilled", "type": "bool"}, {"internalType": "uint256[]", "name": "randomWords", "type": "uint256[]"}], "stateMutability": "view", "type": "function"}, {"inputs": [], "name": "lastRequestId", "outputs": [{"internalType": "uint256", "name": "", "type": "uint256"}], "stateMutability": "view", "type": "function"}, {"inputs": [{"internalType": "address", "name": "", "type": "address"}], "name": "lastWithdraw", "outputs": [{"internalType": "uint256", "name": "", "type": "uint256"}], "stateMutability": "view", "type": "function"}, {"inputs": [], "name": "owner", "outputs": [{"internalType": "address", "name": "", "type": "address"}], "stateMutability": "view", "type": "function"}, {"inputs": [{"internalType": "uint256", "name": "requestId", "type": "uint256"}, {"internalType": "uint256[]", "name": "randomWords", "type": "uint256[]"}], "name": "rawFulfillRandomWords", "outputs": [], "stateMutability": "nonpayable", "type": "function"}, {"inputs": [{"internalType": "uint256", "name": "", "type": "uint256"}], "name": "reel", "outputs": [{"internalType": "uint8", "name": "", "type": "uint8"}], "stateMutability": "view", "type": "function"}, {"inputs": [{"internalType": "uint256", "name": "", "type": "uint256"}], "name": "requestIds", "outputs": [{"internalType": "uint256", "name": "", "type": "uint256"}], "stateMutability": "view", "type": "function"}, {"inputs": [{"internalType": "uint256", "name": "", "type": "uint256"}], "name": "s_requests", "outputs": [{"internalType": "bool", "name": "fulfilled", "type": "bool"}, {"internalType": "bool", "name": "exists", "type": "bool"}, {"internalType": "address", "name": "from", "type": "address"}, {"internalType": "uint256", "name": "bet", "type": "uint256"}], "stateMutability": "view", "type": "function"}, {"inputs": [{"internalType": "uint256", "name": "bet", "type": "uint256"}, {"internalType": "uint32", "name": "spins", "type": "uint32"}], "name": "spin", "outputs": [], "stateMutability": "payable", "type": "function"}, {"inputs": [{"internalType": "address", "name": "to", "type": "address"}], "name": "transferOwnership", "outputs": [], "stateMutability": "nonpayable", "type": "function"}, {"inputs": [{"internalType": "address", "name": "", "type": "address"}], "name": "waitingForResponse", "outputs": [{"internalType": "bool", "name": "", "type": "bool"}], "stateMutability": "view", "type": "function"}, {"inputs": [], "name": "withdraw", "outputs": [], "stateMutability": "nonpayable", "type": "function"}, {"stateMutability": "payable", "type": "receive"}]`);
      this.slot = new this.web3.eth.Contract(abi, slotAddress);
      this.ethPrice = await this.slot.methods.getLatestPrice().call().then(data => { return data }) / 1e8
      this.updatePlayerSlotBalance()
    },

    async updatePlayerSlotBalance() {
      this.playerSlotBalance = await this.slot.methods.addressToBalance(ethereum.selectedAddress).call().then(data => { return data }) / 1e18
    },

    spin() {
      if (this.bet < 0.1 || this.bet > 1 || this.spins < 1 || this.spins > 100) { return }
      this.slot.methods.spin(this.web3.utils.toWei(String(this.bet), 'ether'), this.spins).send(
        {
          from: ethereum.selectedAddress,
          value: this.web3.utils.toWei(String((this.bet * this.spins) / this.ethPrice), 'ether'),
        }).then(() => this.message = "Waiting For Chainlink VRF Response");

      this.slot.events.RequestSent().on('data', async function (event) {
        let reqId = event['returnValues']['requestId'];
        let from = await this.slot.methods.s_requests(reqId).call().then(data => { return data.from })
        if (from.toLowerCase() == ethereum.selectedAddress.toLowerCase()) {
          this.requestId = reqId;
          this.waitingForRespone = true;
        }
      }.bind(this))

      this.slot.events.RequestFulfilled().on('data', function (event) {
        let ret = event['returnValues']
        if (this.requestId == ret['requestId']) {
          this.randomWords = ret['randomWords']
          this.randomWordsCounter = 0;
          this.message = null;
          this.startSlot()
        }
      }.bind(this))
    },

    startSlot() {
      let r1 = this.reel[parseInt((this.randomWords[this.randomWordsCounter] % 100) % 36)]
      let r2 = this.reel[parseInt(((this.randomWords[this.randomWordsCounter] % 10000) / 100) % 36)]
      let r3 = this.reel[parseInt(((this.randomWords[this.randomWordsCounter] % 1000000) / 10000) % 36)]
      this.reel1 = this.symbols[r1]
      this.reel2 = this.symbols[r2]
      this.reel3 = this.symbols[r3]
      this.slotsRunning = true;
      if (r1 == r2) {
        let pos = 0;
        if (r2 == r3) {
          pos = 1;
        }
        this.won = this.bet * this.payouts[r1][pos]
      } else {
        this.won = 0
      }
    },

    nextSlot() {
      if (this.randomWordsCounter < this.randomWords.length - 1) {
        this.randomWordsCounter++
        this.startSlot()
      } else {
        this.slotsRunning = false
        this.waitingForRespone = false
        this.updatePlayerSlotBalance()
      }
    },

    withdraw() {
      this.slot.methods.withdraw().send({ from: ethereum.selectedAddress })
    }
  }
}
</script>