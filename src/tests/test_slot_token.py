import pytest
import brownie

from scripts.utils import eth_to_wei
from scripts.deploy import deploy_all
from scripts.price_feed import get_price


def test_slot_token(SlotToken):
    deploy_all()
    slot_token = SlotToken[-1]
    assert slot_token.totalSupply() == 0
    assert slot_token.name() == 'SlotToken'
    assert slot_token.symbol() == 'SLTKN'
    assert slot_token.decimals() == 18

def test_buy_token(SlotToken, a):
    owner, player = a[0], a[1]
    slot_token = SlotToken[-1]
    price = get_price()[1]
    buy_value = eth_to_wei(0.0063)

    slot_token.buyTokens({'from': player, 'value': buy_value})
    assert slot_token.balanceOf(player) == (buy_value * price) / 1e6
    