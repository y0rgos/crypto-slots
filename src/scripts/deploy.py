from brownie import Slot

def deploy(account):
    slot = Slot.deploy({'from': account })
    return slot