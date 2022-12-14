from brownie import accounts, network
from web3 import Web3

def get_accounts():
    if network.show_active() == 'development':
        return accounts

def eth_to_wei(ether):
    return Web3.toWei(ether, 'ether')

def wei_to_eth(wei):
    return Web3.fromWei(wei, 'ether')