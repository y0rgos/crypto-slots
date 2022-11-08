from brownie import (
    MockAggregatorV3Interface,
    network,
    config,
    a)

from .utils import eth_to_wei, wei_to_eth
from .price_feed import get_price

def main():
    deploy_all()


def deploy_all():
    if network.show_active() == 'development':
        a[0].deploy(MockAggregatorV3Interface, get_price()[1])
        price_feed_address = MockAggregatorV3Interface[-1].address
    elif network.show_active() == 'goerli' or network.show_active() == 'mainnet-fork':
        price_feed_address = config['networks'][network.show_active()]['price_feed_address']