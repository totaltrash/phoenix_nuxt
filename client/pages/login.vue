<template>
  <form @submit.prevent="login" id="log_in_form">
    <div class="min-h-screen flex items-start justify-center md:items-center px-4">
      <Card class="w-full max-w-sm mt-10 md:mt-0">
        <CardHeader>
          <CardTitle class="text-2xl">
            Login
          </CardTitle>
          <CardDescription>
            Enter your email below to login to your account.
          </CardDescription>
        </CardHeader>
        <CardContent class="grid gap-4">
          <Alert v-if="error" variant="destructive" id="alert_error">
            <AlertDescription>
              {{ error }}
            </AlertDescription>
          </Alert>
          <div class="grid gap-2">
            <Label for="username">Username</Label>
            <Input id="username" type="text" v-model="credentials.username" @input="error = null" required autofocus />
          </div>
          <div class="grid gap-2">
            <Label for="password">Password</Label>
            <Input id="password" type="password" v-model="credentials.password" @input="error = null" required />
          </div>
        </CardContent>
        <CardFooter>
          <Button class="w-full" :disabled="loading">
            <template v-if="loading">
              <Loader class="w-4 h-4 mr-2 animate-spin" />
              Signing in...
            </template>
            <template v-else>
              Sign in
            </template>
          </Button>
        </CardFooter>
      </Card>
    </div>
  </form>
</template>

<script setup lang="ts">
import { useApi } from '~/composables/useApi'
import { Loader } from 'lucide-vue-next'

definePageMeta({ layout: 'public' })

const credentials = reactive({
  username: '',
  password: '',
})

const loading = ref(false)
const error = ref<string | null>(null)

const login = async () => {
  const api = useApi()
  error.value = null
  loading.value = true

  try {
    await api('/login', { method: 'POST', body: credentials })
    await navigateTo(useRuntimeConfig().app.baseURL, { external: true })
  } catch (err: any) {
    if (err?.name === 'FetchError' && err?.message.includes('no response')) {
      error.value = `Error: Unable to connect to server`
    }
    else if (err?.response?.status === 401) {
      error.value = 'Error: Invalid username or password'
    }
    else if (err?.response?.status) {
      error.value = `Login failed: ${err.response.statusText}`
    }
    else {
      error.value = 'Unexpected error: Please try again later'
    }
    credentials.password = ''
    console.debug(err)
  } finally {
    loading.value = false
  }
}

</script>
