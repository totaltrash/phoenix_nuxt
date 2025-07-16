<template>
  <h1>User Admin</h1>
  {{ users }}
  <ul>
    <li v-for="user in users" :key="user.id">
      {{ user.id }}, {{ user.username }}, {{ user.firstName }} {{ user.surname }}
    </li>
  </ul>
</template>

<script setup lang="ts">
import { useAccountsDomain } from '~/composables/ash/generated/useAccountsDomain'
import type { User } from '~/types/user'

definePageMeta({
  layout: 'app'
})

const { readAll } = useAccountsDomain()
const users: User[] = await readAll()
</script>