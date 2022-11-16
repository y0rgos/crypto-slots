from pathlib import Path

from brownie import network
from brownie.network import accounts, gas_price
from brownie.network.gas.strategies import LinearScalingStrategy
import brownie.project as project



def fulfill_random_words(log):
    request_id = log['args']['requestId']
    vrf.fulfillRandomWords(request_id, slot, {'from': accounts[0]})

project_path = project.check_for_project(Path(__file__))
if not project_path:
    print('No Project')
    exit()

p = project.load(project_path)
p.load_config()
network.connect('development', False)
gas_strategy = LinearScalingStrategy("10 gwei", "50 gwei", 1.1)
gas_price(gas_strategy)

vrf = p.VRFCoordinatorV2Mock[-1]
slot = p.Slot[-1]
slot_events = slot.events

last_request_id = slot.lastRequestId()

if last_request_id > 0:
    for last_id in range(last_request_id):
        if not slot.s_requests(last_id + 1)['fulfilled']:
            vrf.fulfillRandomWords(last_id + 1, slot, {'from': accounts[0]})


x = slot_events.subscribe('RequestSent', fulfill_random_words, 5)
while True:
    pass

