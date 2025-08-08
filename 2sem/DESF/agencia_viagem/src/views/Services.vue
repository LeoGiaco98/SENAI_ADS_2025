<template>
  <Header />
  <section>
    <h2>Nossos Serviços</h2>
    <ul>
      <li>Pacotes de viagens personalizados</li>
      <li>Suporte 24h durante a viagem</li>
      <li>Reservas de hotéis e passeios</li>
    </ul>
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

