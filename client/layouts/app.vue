<template>
  <ErrorBanner v-if="error" :message="error" />
  <SidebarProvider v-else>
    <AppSidebar />
    <div class="w-full">
      <header class="border-b-1 bg-background text-foreground p-4 flex gap-2">
        <SidebarTrigger />
        <div class="text-lg font-bold">My App</div>
      </header>
      <main class="p-4">
        <slot />
      </main>
    </div>
  </SidebarProvider>
</template>

<script setup lang="ts">
import { useAppStatus } from '~/composables/useAppStatus'

const { error } = useAppStatus()
</script>