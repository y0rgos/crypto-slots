import pytest
import brownie

from scripts.utils import eth_to_wei

def test_slot_token(SlotToken, a):
    owner = a[0]
    owner.deploy(SlotToken)
    slot_token = SlotToken[-1]
    assert slot_token.totalSupply() == eth_to_wei(1000000)
    assert slot_token.name() == 'SlotToken'
    assert slot_token.symbol() == 'SLTKN'
    assert slot_token.decimals() == 18

def test_transfer_token(SlotToken, a):
    owner, player = a[0], a[1]
    slot_token = SlotToken[-1]
    slot_token.transfer(player, eth_to_wei(10), {'from': owner})
    assert slot_token.balanceOf(player) == eth_to_wei(10)
    assert slot_token.balanceOf(owner) == eth_to_wei(1000000-10)
    