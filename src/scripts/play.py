from .deploy import deploy
from .utils import get_accounts, to_ether, to_wei

owner = get_accounts()[0]
player = get_accounts()[1]


def main():
    slot = deploy(owner)
    play(slot)

def play(slot):
    bet = to_wei(0.2)

    while player.balance() >= bet:
        tx = slot.spin({'from': player, 'value': bet})
        tx.wait(1)

        print_results(bet, slot, tx, player)

        if to_ether(tx.return_value[1]) > 0:
            print(f'\tc) Change the Bet (Currently: {to_ether(bet)} Ξ)')
            print(f'\tp) Get owed money (Currently: {to_ether(slot.oweToAddress(player.address))} Ξ)')
            inp = input('Press Enter To Spin')

            if not inp:
                continue
            elif inp == 'p':
                slot.getOwedMoney({'from': player})
                print('Slot balance: ', to_ether(slot.balance()))
                print('Player balance: ', to_ether(player.balance()))
            elif inp == 'c':
                try:
                    new_bet = input('Enter new bet in ether(0.1-1.0): ')
                    new_bet = float(new_bet)
                    if new_bet >= 0.1 and new_bet <= 1:
                        bet = to_wei(new_bet)
                    else:
                        print('Invalid Bet Amount')
                except ValueError as e:
                    print(e)
            else:
                print('Invalid Input')


def print_results(bet, slot, tx, player):
    res = tx.return_value[0]
    print(f'Slot Balance: {to_ether(slot.balance())} Ξ')
    print('====================')
    print(f'=====[{res[0]}][{res[1]}][{res[2]}]======')
    print('====================')
    print(f'!!! Win: {to_ether(tx.return_value[1])} Ξ !!!')
    print(f'Player Balance: {to_ether(player.balance())} Ξ')