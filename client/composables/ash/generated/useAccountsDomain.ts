import { useAshChannel } from '~/composables/ash/core/useAshChannel'
export const useAccountsDomain = () => {
  const { action } = useAshChannel()

  async function readAllUsers(fields: any) {
    const result = await action("accounts", "read_all_users", {}, fields)
    console.log(result)
    return result.data
  }

  return {
    readAllUsers
  }
}
