<template>
    <!-- Button trigger modal -->
    <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#exampleModal">
        Payouts
    </button>

    <!-- Modal -->
    <div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h1 class="modal-title fs-5" id="exampleModalLabel">Payouts</h1>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <table class="table table-dark">
                        <thead>
                            <tr>
                                <th scope="col">#</th>
                                <th scope="col">Symbols</th>
                                <th scope="col">2 Symbols</th>
                                <th scope="col">3 Symbols</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr v-for="(value, key, index) in symbols">
                                <th scope="row">{{ key }}</th>
                                <td>{{ value }}</td>
                                <td>x{{ payouts[key][0] }}</td>
                                <td>x{{ payouts[key][1] }}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <!-- <button type="button" class="btn btn-primary">Save changes</button> -->
                </div>
            </div>
        </div>
    </div>

</template>
<script>
export default {
    data() {
        return {
            symbols: { 0: '🍋', 1: '🍇', 2: '🍉', 3: '🍓', 4: '🍒', 5: '🌶️', 6: '🍌', 7: '🍄' },
            payouts: { 0: [0.2, 2.5], 1: [0.5, 4.5], 2: [1.0, 10.0], 3: [1.5, 25.0], 4: [2.5, 55.0], 5: [4.5, 165.0], 6: [15.0, 655.0], 7: [115.0, 10000.0] },
        }
    }
}
</script>