// Importa o Vue (a ferramenta que usamos para montar o site)
import { createApp } from 'vue'

// Importa o arquivo principal do site (onde está a estrutura do site)
import App from './App.vue'

// Importa o arquivo com as rotas (para trocar de página sem recarregar o site)
import router from './router'

// Cria o site (a aplicação) usando o arquivo App.vue
createApp(App)

  // Adiciona as rotas no site (permite navegar entre páginas)
  .use(router)

  // Mostra o site dentro da parte <div id="app"> no index.html
  .mount('#app')

