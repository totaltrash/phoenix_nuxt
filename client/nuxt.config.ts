// https://nuxt.com/docs/api/configuration/nuxt-config
import tailwindcss from '@tailwindcss/vite'

const target = process.env.TARGET || 'dev'

interface TargetConfig {
  baseURL: string
  buildDir: string
  outputDir: string
  wsUrl: string
  apiUrl: string
}

let targetConfig: TargetConfig

switch (target) {
  case 'dev':
    targetConfig = {
      baseURL: '/',
      buildDir: '.nuxt/dev',
      outputDir: '.output/dev',
      wsUrl: 'ws://localhost:4000/socket',
      apiUrl: 'http://localhost:4000/api'
    }
    break

  case 'wallaby':
    targetConfig = {
      baseURL: '/client_test/',
      buildDir: '.nuxt/wallaby',
      outputDir: '.output/wallaby',
      wsUrl: 'ws://localhost:4002/socket',
      apiUrl: '/api'
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

  buildDir: targetConfig.buildDir,

  app: {
    baseURL: targetConfig.baseURL,
  },

  runtimeConfig: {
    public: {
      wsUrl: targetConfig.wsUrl,
      apiUrl: targetConfig.apiUrl,
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
    server: {
      watch: {
        // don't trigger hmr in dev when `nuxt generate` happens in test
        ignored: ['**/.output/wallaby/**', '**/.nuxt/wallaby/**'],
      },
    },
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
  },
})
