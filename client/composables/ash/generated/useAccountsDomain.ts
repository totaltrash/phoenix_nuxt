import { useAshChannel } from '~/composables/ash/core/useAshChannel'
export const useAccountsDomain = () => {
  const { action } = useAshChannel()

  async function readAllUsers() {
    const result = await action("accounts", "read_all_users", {})
    console.log(result)
    return result.data
  }

  return {
    readAllUsers
  }
}
