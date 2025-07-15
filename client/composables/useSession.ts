import { useApi } from '~/composables/useApi'
import type { User } from '~/types/user'

export const useSession = () => {
  type MeResponse = { user: User }

  const api = useApi()
  const user = useState<User | null>('currentUser', () => null)
  const error = useState<string | null>('sessionError', () => null)

  async function fetchUser() {
    if (user.value) {
      return
    }

    console.log('useSession: Fetching user')

    error.value = null

    try {
      const result = await api<MeResponse>('/me')
      user.value = result.user
    } catch (err: any) {
      if (err?.response?.status === 401) {
        user.value = null
      } else {
        error.value = 'Failed to fetch current user'
        console.error(err)
      }
    }
  }

  function clearUser() {
    user.value = null
  }

  return {
    user,
    // error,
    fetchUser,
    clearUser,
  }
}
