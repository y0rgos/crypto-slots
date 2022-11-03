#TODO: Refactor code with DRY principles

import pytest

from scripts.utils import to_wei


@pytest.fixture(scope='function', autouse=True)
def contract(fn_isolation, OweMechanic, a):
    return OweMechanic.deploy({'from': a[0]})


def test_owes_same_as_owns(contract, a):
    amount_owes = to_wei(1)
    amount_funded = to_wei(1)
    owner, player = a[0], a[1]
    start_balance = to_wei(1000)

    # Ensure clean isolated tests
    assert owner.balance() == start_balance
    assert player.balance() == start_balance
    assert contract.balance() == 0
    assert contract.oweToAddress(player) == 0

    # Contract now owes to player x amount of eth
    contract.oweToSomeone(player, amount_owes,{'from': owner})
    # Prove that the contract owes to player x amount of eth
    assert contract.oweToAddress(player.address) == amount_owes

    # Owner funds the contract 
    owner.transfer(contract, amount_funded)
    # Prove that the new contract balance is what owner funded
    assert contract.balance() == amount_funded

    # Player asks for the owed money
    tx = contract.getOwedMoney({'from': player})
    # Wait 1 block
    tx.wait(1)

    # Check if the new owe amount is correct
    assert contract.oweToAddress(player.address) == 0
    # Check if the contract balance is corrrect
    assert contract.balance() == 0
    # Check if the player balance is correct
    assert player.balance() == to_wei(1000) + amount_owes


def test_owes_more_than_owns(contract, a):
    amount_owes = to_wei(2)
    amount_funded = to_wei(1)
    owner, player = a[0], a[1]
    start_balance = to_wei(1000)

    # Ensure clean isolated tests
    assert owner.balance() == start_balance
    assert player.balance() == start_balance
    assert contract.balance() == 0
    assert contract.oweToAddress(player) == 0

    # Contract now owes to player x amount of eth
    contract.oweToSomeone(player, amount_owes,{'from': owner})
    # Prove that the contract owes to player x amount of eth
    assert contract.oweToAddress(player.address) == amount_owes

    # Owner funds the contract 
    owner.transfer(contract, amount_funded)
    # Prove that the new contract balance is what owner funded
    assert contract.balance() == amount_funded

    # Player asks for the owed money
    tx = contract.getOwedMoney({'from': player})
    # Wait 1 block
    tx.wait(1)

    # Check if the new owe amount is correct
    assert contract.oweToAddress(player.address) == amount_owes - amount_funded
    # Check if the contract balance is corrrect
    assert contract.balance() == 0
    # Check if the player balance is correct
    assert player.balance() == to_wei(1000) + amount_owes - amount_funded
    


def test_owes_less_than_owns(contract, a):
    amount_owes = to_wei(1)
    amount_funded = to_wei(2)
    owner, player = a[0], a[1]
    start_balance = to_wei(1000)

    # Ensure clean isolated tests
    assert owner.balance() == start_balance
    assert player.balance() == start_balance
    assert contract.balance() == 0
    assert contract.oweToAddress(player) == 0

    # Contract now owes to player x amount of eth
    contract.oweToSomeone(player, amount_owes,{'from': owner})
    # Prove that the contract owes to player x amount of eth
    assert contract.oweToAddress(player.address) == amount_owes

    # Owner funds the contract 
    owner.transfer(contract, amount_funded)
    # Prove that the new contract balance is what owner funded
    assert contract.balance() == amount_funded

    # Player asks for the owed money
    tx = contract.getOwedMoney({'from': player})
    # Wait 1 block
    tx.wait(1)

    # Check if the new owe amount is correct
    assert contract.oweToAddress(player.address) == 0
    # Check if the contract balance is corrrect
    assert contract.balance() == amount_funded - amount_owes
    # Check if the player balance is correct
    assert player.balance() == to_wei(1000) + amount_owes