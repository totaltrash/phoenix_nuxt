<template>
  <SidebarProvider>
    <AppSidebar />
    <div class="w-full">
      <header class="border-b-1 bg-background text-foreground p-4 flex gap-2">
        <SidebarTrigger />
        <h1 class="text-lg font-bold">My App</h1>
      </header>
      <main class="p-4">
        <slot />
      </main>
    </div>
  </SidebarProvider>
</template>