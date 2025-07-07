defmodule Test.NuxtHelper do
  @moduledoc """
  Helper for starting or generating the Nuxt client in tests

  Two flavours, generate a nuxt client, which can be served by the Phoenix server during end-to-end tests
  or run a client in the nuxt dev mode.

  Changes to these functions should be done in cahoots with nuxt.config.ts
  """

  @client_dir "client"
  @nuxt_path Path.expand("node_modules/.bin/nuxt", @client_dir)
  @target "wallaby"

  @doc """
  Generate the nuxt client for serving by Phoenix server

  Need to add this to Web.endpoint:

  ```
  if Mix.env() in [:test] do
    plug Plug.Static,
      at: "/client_test",
      from: "client/.output/wallaby/public/"
  end
  ```

  And the following to test_helper.exs:

  ```
  Test.NuxtHelper.generate_nuxt_client!()
  Application.put_env(:wallaby, :base_url, Web.Endpoint.url() <> "/client_test/index.html")
  ```

  Also set the nuxt.config.ts base_url entry for the wallaby target:

  ```
  baseURL: '/client_test/'
  ```
  """
  def generate_nuxt_client! do
    IO.puts("Generating Nuxt client...")

    {_, 0} =
      System.cmd(@nuxt_path, ["generate"],
        cd: @client_dir,
        env: [{"TARGET", @target}]
      )
  end

  # Dev mode module attributes
  @dev_mode_port "3333"
  @wrapper_path Path.expand("../run_wrapper", @client_dir)

  def dev_mode_base_url, do: "http://localhost:#{@dev_mode_port}"

  @doc """
  Run the Nuxt client in dev mode in a wrapper to avoid zombie processes

  This is the least favourite way to run the client in tests... Not convinced
  it works so well, zombie processes were kind of a problem when playing with it
  even though it was quite stable at the end of developing, but changes to
  nuxt config would spam the terminal with broken pipe errors and all sorts of bs

  Will need to add this to test_helper.exs:

  ```
  Test.NuxtHelper.run_nuxt_client!()
  Application.put_env(:wallaby, :base_url, Test.NuxtHelper.dev_mode_base_url())
  ```

  And set the nuxt.config.ts base_url entry for the wallaby target:

  ```
  baseURL: '/'
  ```
  """
  def run_nuxt_client! do
    IO.puts("Run Nuxt client in dev mode...")

    spawn_link(fn ->
      {_, 0} =
        System.cmd(@wrapper_path, [@nuxt_path, "dev"],
          cd: @client_dir,
          env: [{"TARGET", @target}, {"PORT", @dev_mode_port}]
        )
    end)

    :timer.sleep(4000)
  end
end
