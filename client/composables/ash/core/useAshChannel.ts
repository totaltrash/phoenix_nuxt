import { Channel } from 'phoenix'
import { joinChannel, leaveChannel } from '~/lib/socket/socketClient'
import { useSocket } from '~/composables/ash/core/useSocket'

export const useAshChannel = () => {
  const channel = useState<Channel | null>('ash_channel', () => null)

  const join = () => {
    if (channel.value) {
      return
    }

    const { get: getSocket } = useSocket()
    let socket = getSocket()
    if (!socket) {
      throw new Error('socket is undefined — is the plugin running in the client?')
    }

    channel.value = joinChannel(socket, 'ash')
  }

  const leave = () => {
    if (channel.value) {
      leaveChannel(channel.value)
      channel.value = null
    }
  }

  const get = () => {
    return channel.value
  }

  return {
    join,
    leave,
    get,
  }
}
