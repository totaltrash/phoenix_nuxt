defmodule Web.AuthControllerTest do
  use Test.ConnCase

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
end
