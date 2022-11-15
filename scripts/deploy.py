from brownie.network import gas_price, show_active
from brownie.network.gas.strategies import LinearScalingStrategy
from brownie import (
    MockAggregatorV3Interface,
    VRFCoordinatorV2Mock,
    LinkToken,
    Slot,
    config,
    a)
from .price_feed import get_price

gas_strategy = LinearScalingStrategy("10 gwei", "50 gwei", 1.1)

def main():
    deploy_all()


def deploy_all():
    if show_active() == 'development' or show_active() == 'dev':
        price_feed_contract = MockAggregatorV3Interface.deploy(get_price()[1], {'from': a[0], 'gas_price': gas_strategy})
        price_feed_address = price_feed_contract.address

        link_token = LinkToken.deploy({'from': a[0], 'gas_price': gas_strategy})

        vrf_coordinator = VRFCoordinatorV2Mock.deploy(1, 1, {'from': a[0], 'gas_price': gas_strategy})
        vrf_coordinator.createSubscription({'from': a[0], 'gas_price': gas_strategy})
        vrf_coordinator.fundSubscription(1, 100*1e18, {'from': a[0], 'gas_price': gas_strategy})
        tx = vrf_coordinator.getSubscription(1)

        balance, req_count, owner, consumers, = tx
        print(f'{owner} funded {balance/1e18} LinkToken on sub 1')
        print(req_count, consumers)

        slot = Slot.deploy(price_feed_address, 1, vrf_coordinator.address, {'from': a[0],"gas_price": gas_strategy})
        vrf_coordinator.addConsumer(1, slot.address, {'from': a[0],"gas_price": gas_strategy})

