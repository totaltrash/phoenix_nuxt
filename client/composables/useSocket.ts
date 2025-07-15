import { Socket } from 'phoenix'

let socketInstance: Socket | null = null

export const useSocket = () => {
  const config = useRuntimeConfig()
  const socket = useState<Socket | null>('socket', () => null)

  function connectSocket(params?: Record<string, any>) {
    if (socket.value) {
      return socket.value
    }

    console.log('useSocket: Connecting the socket')

    socketInstance = new Socket(config.public.wsUrl, { params })
    socketInstance.connect()
    socket.value = socketInstance

    return socketInstance
  }

  function disconnectSocket() {
    if (socket.value) {
      socket.value.disconnect()
      socket.value = null
      socketInstance = null
    }
  }

  function getSocket() {
    return socket.value
  }

  return {
    connectSocket,
    disconnectSocket,
    getSocket,
    socket,
  }
}
