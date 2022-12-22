<template>

  <main v-if="ethereum">
    <MyHeader :ethereum="ethereum" />
    <SlotMachine :ethereum="ethereum" />
  </main>

  <h1 v-else>Please install MetaMask</h1>

</template>

<script>
import MyHeader from './components/MyHeader.vue';
import SlotMachine from './components/SlotMachine.vue';

export default {

  name: 'App',

  components: {
    MyHeader,
    SlotMachine
  },

  data() {
    return {
      ethereum: null,
    }
  },

  created() {
    let ethereum = window.ethereum;
    if (ethereum) {
      this.ethereum = ethereum
    } else {
      alert("Please install MetaMask")
    }
  },
}
</script>
