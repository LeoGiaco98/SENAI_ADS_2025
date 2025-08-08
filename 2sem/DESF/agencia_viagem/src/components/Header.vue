<template>
  <header>
    <h1>Agência de Viagem</h1>
    <nav>
      <a href="/">Início</a> |
      <a href="/about">Sobre</a> |
      <a href="/services">Serviços</a> |
      <a href="/trem">Trem</a>
    </nav>
  </header>
</template>

<script>
export default {
  name: 'Header'
}
</script>

<style scoped>
header {
  background-color: #eee;
  padding: 1rem;
  text-align: center;
}
nav a {
  margin: 0 10px;
  text-decoration: none;
}
</style>
