
#Not Functional Yet

from pathlib import Path
from web3 import Web3
import json


network = 'dev'
uri='http://127.0.0.1:8545/'


def main():
    w3 = Web3(Web3.HTTPProvider(uri))
    assert w3.isConnected()
    w3.eth.defaultAccount = w3.eth.accounts[1]
    slot_address, slot_abi = load_from_brownie()
    slot = w3.eth.contract(address=slot_address, abi=slot_abi)
    game_loop(w3, slot)
    


def game_loop(w3, slot):
    while True:
        bet_input = input('Enter bet amount (min:$0.1 max:$1.0)(blank=$0.1): ')
        bet = bet_input if bet_input else Web3.toWei(0.1, 'ether')
        spins = input('How many spins:(blank=1): ')
        tx_hash = slot.functions.spin(int(1e18), 100).transact({'value':int(1e18)})
        receipt = w3.eth.wait_for_transaction_receipt(tx_hash)


def load_from_brownie():
    base_dir = Path(__file__).parents[2]
    p = base_dir.joinpath('build/deployments/')

    with p.joinpath(f'map.json').open() as f:
        slot_address = json.loads(f.read())[network]['Slot'][0]
    with p.joinpath(f'{network}/{slot_address}.json').open() as f:
        slot_abi = json.loads(f.read())['abi']

    return (slot_address, slot_abi)




if __name__ == '__main__':
    main()