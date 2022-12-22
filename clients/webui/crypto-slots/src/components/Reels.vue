<template>
    <div class="row border border-dark border-5" style="font-size:100px">
        <div class="col border border-dark">{{ reel1 }}</div>
        <div class="col border border-dark">{{ reel2 }}</div>
        <div class="col border border-dark">{{ reel3 }}</div>
    </div>
    <h1>Win: ${{ won }}</h1>
</template>

<script>
export default {
    data() {
        return {
            reel: [
                0, 0, 0, 0, 0, 0, 0, 0,
                1, 1, 1, 1, 1, 1, 1,
                2, 2, 2, 2, 2, 2,
                3, 3, 3, 3, 3,
                4, 4, 4, 4,
                5, 5, 5,
                6, 6,
                7
            ],
            reel1: 'x',
            reel3: 'x',
            reel2: 'x',
            won: 0
        }
    },

    props: [
        'bet',
        'symbols',
        'randomWords',
        'randomWordsCounter'
    ],

    watch: {
        randomWordsCounter(newCounter, oldCounter) {
            console.log(newCounter, oldCounter);
            if (newCounter < this.randomWords.length) {
                let r1 = this.reel[parseInt((this.randomWords[newCounter] % 100) % 36)]
                let r2 = this.reel[parseInt(((this.randomWords[newCounter] % 10000) / 100) % 36)]
                let r3 = this.reel[parseInt(((this.randomWords[newCounter] % 1000000) / 10000) % 36)]

                this.reel1 = this.symbols[r1]['symbol']
                this.reel2 = this.symbols[r2]['symbol']
                this.reel3 = this.symbols[r3]['symbol']

                if (r1 == r2) {
                    let pos = 0
                    if (r2 == r3) {
                        pos = 1
                    }
                    this.won = this.win(r1, pos)
                } else {
                    this.won = 0
                }
            }
        }
    },
    methods: {
        win(r1, pos) {
            return this.bet * this.symbols[r1]['payout'][pos]
        }
    }

}
</script>