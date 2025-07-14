import { useApi } from '~/composables/useApi'
import type { User } from '~/types/user'

export const useUserSession = () => {
  type MeResponse = { user: User }

  const api = useApi()
  const user = useState<User | null>('currentUser', () => null)
  const loading = useState<boolean>('sessionLoading', () => false)
  const error = useState<string | null>('sessionError', () => null)

  async function fetchUser() {
    if (user.value || loading.value) return

    loading.value = true
    error.value = null

    try {
      const result: MeResponse = await api('/me')
      user.value = result.user
    } catch (err: any) {
      if (err?.response?.status === 401) {
        user.value = null
      } else {
        error.value = 'Failed to fetch current user'
        console.error(err)
      }
    } finally {
      loading.value = false
    }
  }

  function clearUser() {
    user.value = null
  }

  function setUser(newUser: User | null) {
    user.value = newUser
  }

  return {
    user,
    // loading,
    // error,
    fetchUser,
    clearUser,
    setUser,
  }
}
