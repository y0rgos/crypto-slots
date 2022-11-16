# Crypto Slots
[Work In Progress] Autonomous decentralized slot machines with transparent algorithm

# Table of Contents
1. [How To Play](#how-to-play)
2. [Payouts](#payouts)
3. [Math Behind It](#math-behind-it)


## How To Play

Requirements:
- [Ganache]() ```(host=127.0.0.1:8545, chainid=1337, mnemonic=brownie)``` 
- [Python3]() ```(>=3.10)```
- [Poetry]()
- [Node.js (with npm)]()
- Web Browser with [MetaMask]() installed and [configured](#configure-metamask)

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

## Payouts
Symbol combinations are from left to right and must be consecutive

| Numbers | Symbols | 2 Symbols | 3 Symbols |
| ------- | --------| --------- |-----------|
| 0       | 🍋       | x0.2      | x2.5      |
| 1       | 🍇       | x0.5      | x4.5      |
| 2       | 🍉       | x1        | x10       |
| 3       | 🍓       | x1.5      | x25       |
| 4       | 🍒       | x2.5      | x55       |
| 5       | 🌶️       | x4.5      | x165      |
| 6       | 🍌       | x15       | x655      |
| 7       | 🍄       | x115      | x10000    |

## Math Behind It
You can read the math behind on [math.xlsx](math.xlsx)



---

Copyright (C) 2022 y0rgos - All Rights Reserved
