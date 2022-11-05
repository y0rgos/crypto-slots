from web3 import Web3

#TODO: (Maybe) refactor to use brownie

def main():
    latestData = get_price()
    p = latestData[1] / 1e8
    print('/---------------------------------------------------')
    print('|ETH/USD (1 ETH To USD): ', p)
    print('|SLTK/USD (1 SLTKN To USD): ', 0.01)
    print('|ETH/SLTKN (1 ETH To SLTKN): ', p/0.01)
    print('|---------------------------------------------------')
    print('|USD/ETH (1 USD To ETH): ', 1/p)
    print('|USD/SLTKN (1 USD To SLTKN): ', 100)
    print('|SLTKN/ETH (1 SLTKN To ETH): ', 0.01/p)
    print('\\---------------------------------------------------')

def get_price():
    web3 = Web3(Web3.HTTPProvider('https://rpc.ankr.com/eth_goerli'))
    abi = '[{"inputs":[],"name":"decimals","outputs":[{"internalType":"uint8","name":"","type":"uint8"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"description","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint80","name":"_roundId","type":"uint80"}],"name":"getRoundData","outputs":[{"internalType":"uint80","name":"roundId","type":"uint80"},{"internalType":"int256","name":"answer","type":"int256"},{"internalType":"uint256","name":"startedAt","type":"uint256"},{"internalType":"uint256","name":"updatedAt","type":"uint256"},{"internalType":"uint80","name":"answeredInRound","type":"uint80"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"latestRoundData","outputs":[{"internalType":"uint80","name":"roundId","type":"uint80"},{"internalType":"int256","name":"answer","type":"int256"},{"internalType":"uint256","name":"startedAt","type":"uint256"},{"internalType":"uint256","name":"updatedAt","type":"uint256"},{"internalType":"uint80","name":"answeredInRound","type":"uint80"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"version","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"}]'
    # ETH/USD Price Feed address on goerli
    addr = '0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e'
    contract = web3.eth.contract(address=addr, abi=abi)
    latestData = contract.functions.latestRoundData().call()
    return latestData


if __name__ == '__main__':
    main()