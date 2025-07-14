defmodule Web.AuthController do
  use Web, :controller

  alias Web.Security.Authentication

  def login(conn, %{"username" => username, "password" => password} = params) do
    case App.Accounts.get_by_credentials(username, password) do
      {:ok, %App.Accounts.User{} = user} ->
        conn
        |> Authentication.login_user(user, params)
        |> put_status(:ok)
        |> json(build_payload(user))

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

  def logout(%{assigns: %{current_user: _current_user}} = conn, _params) do
    conn
    |> Authentication.logout_user()
    |> put_status(:no_content)
    |> send_resp()
  end

  def logout(conn, _params) do
    conn
    |> put_status(:unauthorized)
    |> send_resp()
  end

  def me(conn, _params) do
    case conn.assigns[:current_user] do
      %App.Accounts.User{} = user ->
        conn
        |> put_status(:ok)
        |> json(build_payload(user))

      _ ->
        conn
        |> send_resp(:unauthorized, "")
    end
  end

  defp build_payload(%App.Accounts.User{} = user) do
    %{user: %{id: user.id}}
  end
end
