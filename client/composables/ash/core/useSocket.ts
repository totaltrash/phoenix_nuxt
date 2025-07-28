import { connectSocket, disconnectSocket } from '~/lib/socket/socketClient'
import { Socket } from 'phoenix'

export const useSocket = () => {
  const config = useRuntimeConfig()
  const socket = useState<Socket | null>('socket', () => null)

  function connect(params?: Record<string, any>): Socket {
    if (!socket.value) {
      socket.value = connectSocket(config.public.wsUrl, params)
    }
    return socket.value
  }

  function disconnect() {
    if (socket.value) {
      disconnectSocket(socket.value)
      socket.value = null
    }
  }

  function get(): Socket | null {
    return socket.value
  }

  return {
    connect,
    disconnect,
    get,
  }
}
