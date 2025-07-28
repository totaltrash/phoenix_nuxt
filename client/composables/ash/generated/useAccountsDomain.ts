import { useAsh } from '~/composables/ash/core/useAsh'
import type { User } from '~/types/user'

export const useAccountsDomain = () => {
  const { action } = useAsh()

  async function readAllUsers(fields: any): Promise<User[]> {
    const result = await action<User[]>("accounts", "read_all_users", {}, fields)
    console.log(result)
    return result
  }

  return {
    readAllUsers
  }
}
