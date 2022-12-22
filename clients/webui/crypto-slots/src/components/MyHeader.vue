<template>
    <header class="p-3 text-bg-dark">
        <div class="container">
            <div class="d-flex flex-wrap align-items-center justify-content-center justify-content-lg-start">

                <ul class="nav col-12 col-lg-auto me-lg-auto mb-2 justify-content-center mb-md-0">
                    <li><a href="#" class="nav-link px-2 text-white">Home</a></li>
                    <li><a href="#" class="nav-link px-2 text-secondary">How It Works</a></li>
                </ul>

                <div class="text-end">
                    <h6 v-if="account">{{ account }}</h6>
                    <button v-else type="button" class="btn btn-warning" @click="connectWallet">Connect Wallet</button>
                </div>
                
            </div>
        </div>
    </header>
</template>

<script>

export default {
    data() {
        return {
            account: null
        }
    },
    props: ['ethereum'],

    created() {
        this.listenToMetaMaskEvents()
        this.checkConnection()
    },

    watch: {
        account(newAccount, oldAccount) {
            console.log(newAccount);
        }
    },

    methods: {
        async connectWallet() {
            let accounts = await this.ethereum.request({ method: 'eth_requestAccounts' })
            this.account = accounts[0]
        },

        async checkConnection() {
            // Maybe change to `ethereum.isConnected()` and `ethereum.selectedAddress` and add `ethereum.on('connect')`
            let accounts = await this.ethereum.request({ method: 'eth_accounts' })
            this.account = accounts[0]
        },

        async listenToMetaMaskEvents() {
            await this.ethereum.on('accountsChanged', (accounts) => {
                this.account = accounts[0]
            })
            await this.ethereum.on('disconnect', () => {
                this.account = null
            });
        }
    },


}
</script>