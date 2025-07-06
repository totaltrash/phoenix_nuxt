defmodule Test.NuxtHelper do
  @client_dir "client"

  def generate_nuxt_client! do
    IO.puts("Generating Nuxt client...")

    {_, 0} =
      System.cmd("npm", ["run", "generate"],
        cd: @client_dir,
        env: [{"TARGET", "wallaby"}]
      )
  end
end
