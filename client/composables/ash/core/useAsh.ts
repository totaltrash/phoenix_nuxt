import { useAshChannel } from '~/composables/ash/core/useAshChannel'

export const useAsh = () => {
  type AshResponse<T> = {
    data: T
  }

  const action = <T>(domain: string, actionName: string, params: any, fields: any): Promise<T> => {
    console.log('Ash action called')
    const { get: getAshChannel } = useAshChannel()
    const channel = getAshChannel()
    if (!channel) {
      throw new Error('Ash channel not joined yet')
    }

    return new Promise((resolve, reject) => {
      channel!
        .push('action', { domain, actionName, params, fields })
        .receive('ok', (response: AshResponse<T>) => {
          resolve(response.data)
        })
        .receive('error', reject)
        .receive('timeout', () => reject(new Error('timeout')))
    })
  }

  return {
    action
  }
}
