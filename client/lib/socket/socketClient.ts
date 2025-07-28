import { Channel, Socket } from 'phoenix'

export function connectSocket(url: string, params?: Record<string, any>): Socket {
  let socket = new Socket(url, { params })
  console.log('socketClient: Connecting socket')
  socket.connect()

  return socket
}

export function disconnectSocket(socket: Socket) {
  socket.disconnect()
}

export function joinChannel(socket: Socket, channelName: string): Channel {
  let channel = socket.channel(channelName)

  channel
    .join()
    .receive('ok', () => {
      console.log(`socketClient: Joined channel ${channelName}`)
    })
    .receive('error', (err) => {
      console.error(JSON.stringify(err))
      throw err
    })

  return channel
}

export function leaveChannel(channel: Channel) {
  channel.leave()
}
