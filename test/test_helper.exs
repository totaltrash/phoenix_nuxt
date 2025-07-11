ExUnit.start()
ExUnit.configure(exclude: [:disabled])
Ecto.Adapters.SQL.Sandbox.mode(App.Repo, :manual)

if System.get_env("GENERATE_CLIENT") != "false" do
  Test.NuxtHelper.generate_nuxt_client!()
end

Application.put_env(:wallaby, :base_url, Web.Endpoint.url() <> "/client_test/")
{:ok, _} = Application.ensure_all_started(:wallaby)
