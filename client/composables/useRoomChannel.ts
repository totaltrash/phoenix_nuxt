import { Channel } from 'phoenix'

export const useRoomChannel = () => {
  const isJoined = ref(false)
  const messages = ref<string[]>([])
  const error = ref<string | null>(null)
  let channel: Channel | null = null

  // const join = () => {
  //   channel!
  //     .join()
  //     .receive('ok', () => {
  //       isJoined.value = true
  //     })
  //     .receive('error', (err) => {
  //       error.value = JSON.stringify(err)
  //     })

  //   channel!.on('poke', (payload) => {
  //     messages.value.push(payload.msg)
  //   })
  // }

  const ping = (msg: string) => {
    if (!channel) {
      throw new Error('Channel not joined yet')
    }

    // const chan = channel
    return new Promise((resolve, reject) => {
      channel!
        .push('ping', { msg })
        .receive('ok', resolve)
        .receive('error', reject)
        .receive('timeout', () => reject(new Error('timeout')))
    })
  }

  onBeforeMount(() => {
    const { $socket } = useNuxtApp()
    if (!$socket) {
      throw new Error('$socket is undefined — is the plugin running in the client?')
    }

    channel = $socket.channel('room:lobby')

    channel!
      .join()
      .receive('ok', () => {
        isJoined.value = true
      })
      .receive('error', (err) => {
        error.value = JSON.stringify(err)
      })

    channel!.on('poke', (payload) => {
      messages.value.push(payload.msg)
    })
  })
  onBeforeUnmount(() => {
    channel?.leave()
  })

  return {
    // join,
    ping,
    isJoined,
    messages,
    error,
  }
}