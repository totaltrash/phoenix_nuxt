// https://nuxt.com/docs/api/configuration/nuxt-config
import tailwindcss from '@tailwindcss/vite'

const target = process.env.TARGET || 'dev'

interface TargetConfig {
  baseURL: string
  outputDir: string
  wsUrl: string
}

let targetConfig: TargetConfig

switch (target) {
  case 'dev':
    targetConfig = {
      baseURL: '/',
      wsUrl: 'ws://localhost:4000/socket',
      outputDir: '.output/dev',
    }
    break

  case 'wallaby':
    targetConfig = {
      baseURL: '/client_test/',
      wsUrl: 'ws://localhost:4002/socket',
      outputDir: '.output/wallaby',
    }
    break

  // case 'prod':
  //   targetConfig = {
  //     baseURL: '/',
  //     outputDir: '.output/prod',
  //     wsUrl: 'wss://myapp.com/socket',
  //   }
  //   break

  default:
    throw new Error(
      `❌ Unknown TARGET "${target}".\nValid options: dev, wallaby`
    )
}

export default defineNuxtConfig({
  compatibilityDate: '2025-05-15',
  devtools: { enabled: true },

  app: {
    baseURL: targetConfig.baseURL,
  },

  runtimeConfig: {
    public: {
      wsUrl: targetConfig.wsUrl,
    }
  },

  nitro: {
    output: {
      dir: targetConfig.outputDir,
    }
  },

  css: ['~/assets/css/tailwind.css'],

  vite: {
    plugins: [
      tailwindcss(),
    ],
  },

  modules: ['shadcn-nuxt'],

  shadcn: {
    /**
     * Prefix for all the imported component
     */
    prefix: '',
    /**
     * Directory that the component lives in.
     * @default "./components/ui"
     */
    componentDir: './components/ui'
  }
})
