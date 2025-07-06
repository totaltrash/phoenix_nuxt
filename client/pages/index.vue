<template>
  <header>
    <nav>
      <ul>
        <li>
          <NuxtLink to="/">Index</NuxtLink>
        </li>
        <li>
          <NuxtLink to="/other">Other</NuxtLink>
        </li>
      </ul>
    </nav>
  </header>
  <main>
    <h1>Playing with Nuxt and Phoenix</h1>
    <div>
      WS URL: {{ wsUrl }}
    </div>
    <button @click="sendPing" :disabled="!isJoined">Send Ping</button>
    <ul>
      <li v-for="(msg, idx) in messages" :key="idx">{{ msg }}</li>
    </ul>
  </main>
</template>


<script setup lang="ts">
const { ping, isJoined, messages } = useRoomChannel()
const wsUrl = useRuntimeConfig().public.wsUrl

const sendPing = async () => {
  const res = await ping("hello from Nuxt")
  console.log("📬 Server replied:", res)
}
</script>
