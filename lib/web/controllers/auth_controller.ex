defmodule Web.AuthController do
  use Web, :controller

  alias Web.Security.Authentication

  def login(conn, %{"username" => username, "password" => password} = params) do
    case App.Accounts.get_by_credentials(username, password) do
      {:ok, %App.Accounts.User{} = user} ->
        Authentication.login_user(conn, user, params)

      _ ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "Invalid credentials"})
    end
  end

  def login(conn, _) do
    Bcrypt.no_user_verify()

    conn
    |> put_status(:unauthorized)
    |> json(%{error: "Invalid credentials"})
  end
end
