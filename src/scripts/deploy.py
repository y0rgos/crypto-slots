from brownie import Slot, accounts

def main():
    Slot.deploy({'from': accounts[0]})
    slot = Slot[-1]
    tx = slot.spin({'from': accounts[0]})
    tx.wait(1)
    r = slot.global_result
    print(r(0), r(1), r(2))