defmodule Web.AuthControllerTest do
  use Test.ConnCase

  @moduledoc """
  Integration testing the /api/login and /api/me endpoints

  See test/browser/auth/ tests for higher level testing around login flows
  """

  test "valid login", %{conn: conn} do
    {user, password} = insert_user(%{with_raw_password: true})
    conn = post(conn, ~p"/api/login", %{"username" => user.username, "password" => password})
    assert response(conn, 204)
    assert get_session(conn, :user_token) != nil
  end

  test "bad username", %{conn: conn} do
    conn = post(conn, ~p"/api/login", %{"username" => "baduser", "password" => "badpass"})
    body = json_response(conn, 401)
    assert "Invalid credentials" == Map.get(body, "error")
  end

  test "bad password", %{conn: conn} do
    user = insert_user()
    conn = post(conn, ~p"/api/login", %{"username" => user.username, "password" => "BadP@ssword"})
    body = json_response(conn, 401)
    assert "Invalid credentials" == Map.get(body, "error")
  end

  test "no roles", %{conn: conn} do
    {user, password} = insert_user(%{with_raw_password: true, roles: []})
    conn = post(conn, ~p"/api/login", %{"username" => user.username, "password" => password})
    body = json_response(conn, 401)
    assert "Invalid credentials" == Map.get(body, "error")
  end

  test "bad params", %{conn: conn} do
    {user, password} = insert_user(%{with_raw_password: true})

    conn =
      post(conn, ~p"/api/login", %{"bad_username" => user.username, "bad_password" => password})

    body = json_response(conn, 401)
    assert "Invalid credentials" == Map.get(body, "error")
  end

  test "me endpoint", %{conn: conn} do
    user = insert_user()

    conn =
      conn
      |> login_user(user)
      |> get(~p"/api/me")

    body = json_response(conn, 200)
    assert body["user"]["id"] == user.id
  end

  test "me endpoint, no current user", %{conn: conn} do
    conn = get(conn, ~p"/api/me")
    assert response(conn, 401) == ""
  end

  test "logout", %{conn: conn} do
    user = insert_user()

    conn =
      conn
      |> login_user(user)
      |> post(~p"/api/logout")

    assert response(conn, 204) == ""
  end

  test "logout but not logged in", %{conn: conn} do
    conn =
      conn
      |> post(~p"/api/logout")

    assert response(conn, 401) == ""
  end
end
