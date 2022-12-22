# Crypto Slots
[Work In Progress] Autonomous decentralized slot machines with transparent algorithm


# Table of Contents
1. [How To Play](#how-to-play)
2. [Made With](#made-with)
4. [Math Behind It](#math-behind-it)


## How To Play

Requirements:
- [Ganache](https://www.npmjs.com/package/ganache-cli)
- [Python3](https://www.python.org/) ```(>=3.10)```
- [Poetry](https://python-poetry.org/)
- [Node.js (with npm)](https://nodejs.org/en/)
- Web Browser with [MetaMask](https://metamask.io/) installed and [configured](#configure-metamask)

### Blockchain section:

1. Clone or download the repository and cd into it.
```
git clone https://github.com/y0rgos/crypto-slots.git && cd crypto-slots
```
2. Create virtual environment and install dependencies.
```
poetry install
```
3. Start Ganache CLI (or GUI with host=```127.0.0.1:8545```, chainid=```1337```, mnemonic=```brownie```).
```
ganache-cli -m brownie
```
4. Deploy contracts and run mock VRF operator.
```
chmod +x deploy.sh && ./deploy.sh
```

### Frontend Section:
1. Change directory to the Vue project.
```
cd clients/webui/crypto-slots
```
2. Install the dependencies.
```
npm install
```
3. Start the frontend
```
npm run dev
```
4. Open a browser and go to [localhost:5173](http://localhost:5173/)

### Configure MetaMask

1. Click Profile Icon > Settings > Advanced > Show test networks > On
2. Now connect to ```Localhost 8545``` network
3. Click Profile Icon > Import Account > Add Private Key ```0x804365e293b9fab9bd11bddd39082396d56d30779efbb3ffb0a6089027902c4a```

#### Done, you are ready to play now.

## Made With

- Frontend : VueJs
- Blockchain: EVM
- Smart Contract: Solidity
- Framework: Brownie
- Oracles: Chainlink VRF, Chainlink Price Feeds

## Math Behind It
You can read the math behind on [math.xlsx](math.xlsx)



---

Copyright (C) 2022 y0rgos - All Rights Reserved
