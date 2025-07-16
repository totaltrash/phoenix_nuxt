import { useAshChannel } from '~/composables/ash/core/useAshChannel'
export const useAccountsDomain = () => {
  const { action } = useAshChannel()

  async function readAll() {
    const result = await action("read_all", {})
    console.log(result)
    return result.data
  }

  return {
    readAll
  }
}
