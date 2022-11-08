from price_feed import get_price

def main():
    price = get_price()[1]
    msg_value = int(0.065*1e18)
    msg_value_in_usd = (msg_value * price) / 1e8
    bet = 1 * 1e18
    spins = 100
    print('=' * 70)
    print(f'1 ETH(Ξ) = {price/1e8} USD($)')
    print(f'msg.value = | {msg_value} ether | {msg_value_in_usd/1e18} USD($) |')
    print(f'Bet = | {bet} ether | {bet/1e18} USD($) |')
    print(f'Spins = {spins}')
    print(f'Spins * Bet = {(spins*bet)/1e18} USD($)')
    print(f'Money sent is equal or more than spins*bet: {msg_value_in_usd>=spins*bet}')
    print('=' * 70)
    spin(bet, spins, msg_value, price)



def spin(bet, spins, msg_value, price):
    assert spins >=1 and spins <= 100
    assert bet >= 0.1*1e18 and bet <= 1*1e18
    spins_value = bet*spins
    sent_value = (msg_value * price) / 1e8
    assert sent_value >= spins_value

if __name__ == '__main__':
    main()