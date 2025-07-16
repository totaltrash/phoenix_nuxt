import { useSession } from '~/composables/useSession'
import { useSocket } from '~/composables/useSocket'
import { useAshChannel } from '~/composables/ash/core/useAshChannel'
// import { useAppStatus } from '~/composables/useAppStatus'

// More than just an auth middleware
//
// Coordinates all the services that need to happen when logged in, such as the socket... more to come
export default defineNuxtRouteMiddleware(async (to) => {
  const { user, userToken, fetchUser } = useSession()
  const { connectSocket } = useSocket()
  const { join: joinAshChannel } = useAshChannel()

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

  // we're logged in and we're going to a protected route, so connect the socket, join the ash channel etc
  connectSocket({ token: userToken.value })
  joinAshChannel()

  if (redirect) {
    return navigateTo(redirect)
  }
})
