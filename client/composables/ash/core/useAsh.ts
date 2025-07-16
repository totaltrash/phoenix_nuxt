// NOT CURRENTLY USED - might be needed between the useAccountsDomain and useAshChannel. Delete if not
import { useAshChannel } from '~/composables/ash/core/useAshChannel'
export const useAsh = () => {
  const { action: channelAction } = useAshChannel()
  function action(name: string, params?: any) {
    return channelAction(name, params)
  }

  return {
    action
  }
}
