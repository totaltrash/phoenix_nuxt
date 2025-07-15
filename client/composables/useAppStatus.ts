export const useAppStatus = () => {
  const error = useState<string | null>('appError', () => null)
  return { error }
}
