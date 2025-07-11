defmodule Test.BrowserCase do
  @moduledoc """
  This module defines the test case to be used by Wallaby powered browser tests.
  """

  use ExUnit.CaseTemplate
  use Wallaby.DSL
  use Web, :verified_routes

  import Test.Context

  using do
    quote do
      use Wallaby.DSL
      import Wallaby.Feature
      import Test.Factory
      import Test.CssSelectors
      import Test.BrowserCase

      use Web, :verified_routes

      # The default endpoint for testing
      @endpoint Web.Endpoint
    end
  end

  setup tags do
    # We'll use the sandbox setup already in DataCase
    Test.DataCase.setup_sandbox(tags)

    # This is the Wallaby directed way to go (when not `use`ing Wallaby.Feature)
    # :ok = Ecto.Adapters.SQL.Sandbox.checkout(App.Repo)
    #
    # unless tags[:async] do
    #   Ecto.Adapters.SQL.Sandbox.mode(App.Repo, {:shared, self()})
    # end

    # Either way, I haven't been able to get LiveView working with async Wallaby tests, so have disabled
    # all the stuff that was supposed to make Wallaby work with LiveView (see the doco to try adding it back in).

    # Even without async, we may need this if we get lots of connection checkout errors, it's helped before
    # on_exit(fn -> Process.sleep(100) end)

    context =
      %{}
      |> set_session_context()
      |> set_user_context(tags)
      |> login_session_context(tags)

    {:ok, context}
  end

  defp set_session_context(context) do
    metadata = Phoenix.Ecto.SQL.Sandbox.metadata_for(App.Repo, self())
    {:ok, session} = Wallaby.start_session(metadata: metadata)

    context
    |> Map.put(:session, session)
    |> Map.put(:sandbox_metadata, metadata)
  end

  defp login_session_context(
         %{session: session, user: user, raw_password: raw_password} = context,
         tags
       ) do
    if tags[:login] == false do
      context
    else
      session =
        session
        |> visit(login_route())
        |> login(user.username, raw_password)
        |> assert_logged_in()

      Map.put(context, :session, session)
    end
  end

  defp login_session_context(context, _tags) do
    context
  end

  def login(session, username, password) do
    session
    |> fill_in(Query.text_field("Username"), with: username)
    |> fill_in(Query.text_field("Password"), with: password)
    |> click(Query.button("Login"))
  end

  def assert_logged_in(session) do
    assert_has(session, Query.css("h1", text: "Home"))
  end

  def login_route, do: "/login"
end
