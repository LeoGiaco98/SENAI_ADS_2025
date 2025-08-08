<template>
    <Header />
    <section class="trem_cards">
        <div class="card_trem1">
            <h2>Trem fumacento</h2>
            <img scr="/src/assets/07102129441092.jpg">
        </div>
        <div class="card_trem2">
            <h2>Trem rapidão</h2>
        </div>
        <div class="card_trem3">
            <h2>Trem bão</h2>
        </div>
    </section>
    <Footer />
</template>

<script>
import Header from '../components/Header.vue'
import Footer from '../components/Footer.vue'

export default {
  components: { Header, Footer }
}
</script>

<style scoped>
div h2 {
    background-color: rgb(83, 172, 255);
    padding: 1rem;
    color: white;
    border-radius: 5px;
    font-family: 'Verdana';
}

.trem_cards {
    display: flex;
    gap: 20px;
    justify-content: space-around;
}
</style>