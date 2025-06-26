import { Socket } from 'phoenix'
// import phoenix from 'phoenix'
export default defineNuxtPlugin(() => {
  // const { Socket } = phoenix
  const socket = new Socket(useRuntimeConfig().public.wsUrl)
  socket.connect()
  console.log(socket)

  return {
    provide: {
      socket
    }
  }
})
