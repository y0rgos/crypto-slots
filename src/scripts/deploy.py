from brownie import (
    MockAggregatorV3Interface,
    SlotToken,
    network,
    config,
    a)

from .utils import eth_to_wei, wei_to_eth
from .price_feed import get_price

def main():
    deploy_all()
    owner = a[0]

    price = get_price()[1] # ETH / USD
    buy_value = eth_to_wei(0.0065)

    slot_token = SlotToken[-1]

    print(slot_token.getLatestPrice())
    print(buy_value/1e18 * price/1e6)
    slot_token.buyTokens({'from': owner, 'value': buy_value})
    print(wei_to_eth(slot_token.balanceOf(owner)))


def deploy_all():
    if network.show_active() == 'development':
        a[0].deploy(MockAggregatorV3Interface, get_price()[1])
        price_feed_address = MockAggregatorV3Interface[-1].address
    elif network.show_active() == 'goerli' or network.show_active() == 'mainnet-fork':
        price_feed_address = config['networks'][network.show_active()]['price_feed_address']
    a[0].deploy(SlotToken, price_feed_address)
    
