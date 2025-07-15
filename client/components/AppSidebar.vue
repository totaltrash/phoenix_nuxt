<script setup lang="ts">
import { LogOut, Home, Inbox, Search, Settings, ArrowUpDown, Squirrel } from "lucide-vue-next"
import { useSidebar } from "./ui/sidebar"
import { useApi } from "~/composables/useApi"
import { useSession } from '~/composables/useSession'
const { clearUser } = useSession()
const api = useApi()

const route = useRoute()

// Menu items.
const items = [
  {
    title: "Home",
    url: "/",
    icon: Home,
  },
  {
    title: "Ping",
    url: "/ping",
    icon: ArrowUpDown,
  },
  {
    title: "Other",
    url: "/other",
    icon: Squirrel,
  },
  // {
  //   title: "LogOut",
  //   url: "#",
  //   icon: LogOut,
  // },
  // {
  //   title: "Search",
  //   url: "#",
  //   icon: Search,
  // },
  // {
  //   title: "Settings",
  //   url: "#",
  //   icon: Settings,
  // },
]

const isActive = (url: string) => {
  return route.path === url
}

async function logOut() {
  console.log('Log out clicked')
  await api('/logout', { method: 'POST' })
  clearUser()
  await navigateTo('/login')
}

</script>

<template>
  <Sidebar collapsible="icon">
    <SidebarContent>
      <SidebarGroup>
        <SidebarGroupLabel>Application</SidebarGroupLabel>
        <SidebarGroupContent>
          <SidebarMenu>
            <SidebarMenuItem v-for="item in items" :key="item.title">
              <SidebarMenuButton asChild :is-active="isActive(item.url)">
                <NuxtLink :to="item.url" class="flex items-center gap-2">
                  <component :is="item.icon" />
                  <span>{{ item.title }}</span>
                </NuxtLink>
              </SidebarMenuButton>
            </SidebarMenuItem>
            <SidebarMenuItem>
              <SidebarMenuButton @click="logOut">
                <LogOut />
                <span>Log out</span>
              </SidebarMenuButton>
            </SidebarMenuItem>
          </SidebarMenu>
        </SidebarGroupContent>
      </SidebarGroup>
    </SidebarContent>
  </Sidebar>
</template>