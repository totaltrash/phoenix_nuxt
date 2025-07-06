// https://nuxt.com/docs/api/configuration/nuxt-config

const target = process.env.TARGET || 'dev'

const targetConfig = {
  // dev client will only be run by npm run dev. will be available on port 3000
  dev: {
    baseURL: '/',
    outputDir: '.output/dev',
    wsUrl: 'ws://localhost:4000/socket',
  },
  // wallaby client will only be run by npm run generate and served by the phoenix dev server, so no port required
  wallaby: {
    baseURL: '/client_test/',
    outputDir: '.output/wallaby',
    wsUrl: 'ws://localhost:4002/socket',
  },
  // prod: {
  //   baseURL: '/',
  //   outputDir: '.output/prod',
  //   wsUrl: 'wss://myapp.com/socket',
  // }
}[target]

export default defineNuxtConfig({
  compatibilityDate: '2025-05-15',
  devtools: { enabled: true },
  app: {
    baseURL: targetConfig?.baseURL,
  },
  runtimeConfig: {
    public: {
      wsUrl: targetConfig?.wsUrl,
    }
  },
  nitro: {
    output: {
      dir: targetConfig?.outputDir,
    }
  },
})
