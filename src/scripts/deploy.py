from brownie import Slot, accounts

def main():
    Slot.deploy({'from': accounts[0]})
    slot = Slot[-1]
    while True:
        input('Press Enter To Spin')
        tx = slot.spin({'from': accounts[0], 'value': 10**18})
        tx.wait(1)
        print(tx.return_value)
