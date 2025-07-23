import { Channel } from 'phoenix'
import { useSocket } from '~/composables/useSocket'

export const useAshChannel = () => {
  const isJoined = ref(false)
  const error = ref<string | null>(null)
  const channel = useState<Channel | null>('channel', () => null)

  const join = () => {
    if (channel.value) {
      return channel.value
    }

    const { getSocket } = useSocket()
    let socket = getSocket()
    if (!socket) {
      throw new Error('socket is undefined — is the plugin running in the client?')
    }

    channel.value = socket.channel('ash')

    channel.value!
      .join()
      .receive('ok', () => {
        isJoined.value = true
        console.log('Ash channel joined')
      })
      .receive('error', (err) => {
        error.value = JSON.stringify(err)
      })
  }

  const action = (domain: string, actionName: string, params: any, fields: any) => {
    console.log('Ash channel action called')
    if (!channel.value) {
      throw new Error('Ash channel not joined yet')
    }

    return new Promise((resolve, reject) => {
      channel.value!
        .push('action', { domain, actionName, params, fields })
        .receive('ok', resolve)
        .receive('error', reject)
        .receive('timeout', () => reject(new Error('timeout')))
    })
  }

  return {
    action,
    isJoined,
    error,
    join,
  }
}