defmodule Test.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use Web.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate
  import Phoenix.ConnTest

  using do
    quote do
      # The default endpoint for testing
      @endpoint Web.Endpoint

      use Web, :verified_routes

      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import Test.ConnCase
      import Test.Factory
    end
  end

  setup tags do
    Test.DataCase.setup_sandbox(tags)
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

  @doc """
  Emulate logging in a user by stashing the token and other stuff into the test session

  Keep this in sync with Web.Security.Authentication.login_user()
  """
  def login_user(conn, %App.Accounts.User{} = user) do
    token =
      user.id
      |> App.Accounts.create_session_token!()
      |> Map.get(:token)

    session = %{
      user_token: token,
      ashjs_socket_id: "users_sessions:#{Base.url_encode64(token)}"
    }

    init_test_session(conn, session)
  end
end
