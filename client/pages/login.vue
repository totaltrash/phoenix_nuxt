<template>
  <form @submit.prevent="login">
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
          <div class="grid gap-2">
            <Label for="username">Username</Label>
            <Input id="username" type="text" v-model="username" required />
          </div>
          <div class="grid gap-2">
            <Label for="password">Password</Label>
            <Input id="password" type="password" v-model="password" required />
          </div>
        </CardContent>
        <CardFooter>
          <Button class="w-full">
            Sign in
          </Button>
        </CardFooter>
      </Card>
    </div>
  </form>
</template>

<script setup lang="ts">
definePageMeta({
  layout: 'public'
})

const username = ref('someuser')
const password = ref('SomeP@ss')
const returnTo = ref(null)

const login = async () => {
  const payload = {
    username: username.value,
    password: password.value,
  }

  $fetch('http://localhost:4000/api/login', {
    method: 'POST',
    body: payload,
    credentials: 'include',
  })
    .then(async () => {
      // Refresh the session on client-side and redirect to the home page
      // await refreshSession()
      // await navigateTo('/')
      console.log('Is good')
    })
    .catch((reason) => {
      console.log('Error')
      console.log(reason)
    })
}
</script>
