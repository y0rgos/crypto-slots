from brownie import Slot, accounts
from web3 import Web3

owner_acc = accounts[0]
player_acc = accounts[1]

def main():
    Slot.deploy({'from': owner_acc })
    slot = Slot[-1]
    #owner_acc.transfer(slot, '10 ether')

    bet = Web3.toWei(0.2, 'ether')

    #player_acc.transfer(0x0, '980 ether')
    while player_acc.balance() >= bet:
        tx = slot.spin({'from': player_acc, 'value': bet})
        tx.wait(1)
        print(tx.return_value[0])
        print('Bet: ', Web3.fromWei(bet, 'ether'))
        print('Slot balance: ', Web3.fromWei(slot.balance(), 'ether'))
        print('Win: ', Web3.fromWei(tx.return_value[1], 'ether'))
        print('Player balance: ', Web3.fromWei(player_acc.balance(), 'ether'))
        print('Owes to player: ', Web3.fromWei(slot.oweToAddress(player_acc.address), 'ether'))
        if Web3.fromWei(tx.return_value[1], 'ether') > 0:
            inp = input('Press Enter To Spin')
            if 'r' in inp:
                slot.getOwedMoney({'from': player_acc})
                print('Slot balance: ', Web3.fromWei(slot.balance(), 'ether'))
                print('Player balance: ', Web3.fromWei(player_acc.balance(), 'ether'))
