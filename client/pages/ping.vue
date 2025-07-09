<template>

  <h1>Playing with Nuxt and Phoenix</h1>
  <div>
    WS URL: {{ wsUrl }}
  </div>
  <Button @click="sendPing" :disabled="!isJoined">Send Ping</Button>
  <ul>
    <li v-for="(msg, idx) in messages" :key="idx">{{ msg }}</li>
  </ul>
</template>


<script setup lang="ts">
definePageMeta({
  layout: 'app'
})

const { ping, isJoined, messages } = useRoomChannel()
const wsUrl = useRuntimeConfig().public.wsUrl

const sendPing = async () => {
  const res = await ping("hello from Nuxt")
  console.log("📬 Server replied:", res)
}
</script>
