<template>
  Error!: {{ message }}
</template>

<script setup lang="ts">
const props = defineProps(['message'])
</script>