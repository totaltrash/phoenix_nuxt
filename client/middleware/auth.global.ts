import { useUserSession } from '~/composables/useUserSession'

export default defineNuxtRouteMiddleware(async (to) => {
  const { user, fetchUser } = useUserSession()

  if (to.path === '/login') {
    await fetchUser()

    if (user.value) {
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

  console.log('Auth: Moving to selected route')
})