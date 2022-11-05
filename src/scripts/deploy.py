from brownie import (
    MockAggregatorV3Interface,
    SlotToken,
    a)

from .utils import eth_to_wei, wei_to_eth
from .price_feed import get_price

def main():
    owner = a[0]

    price = get_price()[1] # ETH / USD

    buy_value = eth_to_wei(0.0065)

    price_feed_contract = owner.deploy(MockAggregatorV3Interface, price)
    slot_token = owner.deploy(SlotToken, price_feed_contract.address)
    print(slot_token.getLatestPrice())
    print(buy_value/1e16 * price/1e8)
    slot_token.buy({'from': owner, 'value': buy_value})
    print(wei_to_eth(slot_token.balanceOf(owner)))
