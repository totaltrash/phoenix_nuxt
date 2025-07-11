<template>
  <SidebarProvider>
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