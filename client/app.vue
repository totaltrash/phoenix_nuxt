<template>
  <div>
    <NuxtRouteAnnouncer />
    <div>
      <button @click="sendPing" :disabled="!isJoined">Send Ping</button>
      <ul>
        <li v-for="(msg, idx) in messages" :key="idx">{{ msg }}</li>
      </ul>
    </div>
  </div>
</template>

<script setup lang="ts">
const { ping, isJoined, messages } = useRoomChannel()

const sendPing = async () => {
  const res = await ping("hello from Nuxt")
  console.log("📬 Server replied:", res)
}
</script>