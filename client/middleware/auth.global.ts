import { useUserSession } from '~/composables/useUserSession'
import { useSocket } from '~/composables/useSocket'

export default defineNuxtRouteMiddleware(async (to) => {
  const { user, fetchUser } = useUserSession()
  const { connectSocket } = useSocket()

  // public paths, no fetch user, or socket/channel
  if (to.path === '/test_public') {
    console.log('Auth: Test public, no fetchUser')
    return
  }

  if (to.path === '/login') {
    await fetchUser()

    if (user.value) {
      connectSocket()
      console.log('Auth: Already logged in, redirecting to home')
      return navigateTo('/')
    }

    return
  }

  // only fetch if we haven’t already got it stored in state
  if (!user.value) {
    console.log('Auth: Fetching user')
    await fetchUser()
  }

  if (!user.value) {
    console.log('Auth: Redirecting to login')
    return navigateTo(`/login?dest=${encodeURIComponent(to.fullPath)}`)
  }
  connectSocket()
  console.log('Auth: Moving to selected route')
})