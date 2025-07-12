export const useApi = () => {
  const config = useRuntimeConfig()

  return $fetch.create({
    baseURL: config.public.apiUrl as string,
    credentials: 'include',
  })
}
