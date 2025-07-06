import { Socket } from 'phoenix'

export default defineNuxtPlugin(() => {
  const socket = new Socket(useRuntimeConfig().public.wsUrl)
  socket.connect()

  return {
    provide: {
      socket
    }
  }
})
