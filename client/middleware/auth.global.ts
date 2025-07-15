import { useSession } from '~/composables/useSession'
import { useSocket } from '~/composables/useSocket'
// import { useAppStatus } from '~/composables/useAppStatus'

// More than just an auth middleware
//
// Coordinates all the services that need to happen when logged in, such as the socket... more to come
export default defineNuxtRouteMiddleware(async (to) => {
  const { user, fetchUser } = useSession()
  const { connectSocket } = useSocket()

  // const { error } = useAppStatus()
  // error.value = null

  // public path, go there without getting the user or setting up the socket
  if (to.path === '/test_public') {
    return
  }

  await fetchUser()

  let redirect: string | null = null

  if (to.path === '/login') {
    if (!user.value) {
      // not currently logged in so go there
      return
    }

    // don't go to /login if already logged in
    redirect = '/'
  }

  if (!user.value) {
    // not logged in, so go to login and give the requested route as a destination after login
    return navigateTo(`/login?dest=${encodeURIComponent(to.fullPath)}`)
  }

  // we're logged in and we're going to a protected route, so connect the socket etc
  connectSocket()

  if (redirect) {
    return navigateTo(redirect)
  }
})
