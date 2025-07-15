import { useApi } from '~/composables/useApi'
import type { User } from '~/types/user'

export const useSession = () => {
  type MeResponse = { user: User, userToken: string }

  const api = useApi()
  const user = useState<User | null>('sessionUser', () => null)
  const userToken = useState<string | null>('sessionUserToken', () => null)
  const error = useState<string | null>('sessionError', () => null)

  async function fetchUser() {
    if (user.value) {
      return
    }

    console.log('useSession: Fetching user')

    error.value = null

    try {
      const result = await api<MeResponse>('/me')
      // console.log(result)
      user.value = result.user
      userToken.value = result.userToken
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
    userToken,
    // error,
    fetchUser,
    clearUser,
  }
}
