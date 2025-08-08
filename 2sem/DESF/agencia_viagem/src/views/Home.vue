<template>
  <Header />
  <section>
    <h2>Bem-vindo à nossa agência!</h2>
    <div class="cards">
      <div class="card">Destino 1</div>
      <div class="card">Destino 2</div>
      <div class="card">Destino 3</div>
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
section h2 {
  text-align: center;
  font-family: 'Verdana';
}

.cards {
  display: flex;
  justify-content: space-around;
  margin: 2rem 0;
}
.card {
  background-color: #008cff;
  color: white;
  padding: 1rem;
  border: 1px solid #ccc;
  width: 30%;
  text-align: center;
  font-family: 'Verdana';
}
</style>


