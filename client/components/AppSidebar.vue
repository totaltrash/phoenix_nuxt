<script setup lang="ts">
import { Calendar, Home, Inbox, Search, Settings, ArrowUpDown, Squirrel } from "lucide-vue-next"
import { useSidebar } from "./ui/sidebar"

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
  //   title: "Calendar",
  //   url: "#",
  //   icon: Calendar,
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
          </SidebarMenu>
        </SidebarGroupContent>
      </SidebarGroup>
    </SidebarContent>
  </Sidebar>
</template>