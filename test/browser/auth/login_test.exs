defmodule Test.Browser.Auth.LoginTest do
  use Test.BrowserCase

  @moduletag login: false

  feature "successful login", %{session: session, user: user, raw_password: raw_password} do
    session
    |> visit(login_route())
    |> assert_has(login_form())
    |> fill_form(user.username, raw_password)
    |> assert_has(Query.css(page_heading(), text: "Home"))
  end

  @tag user: %{username: "BAMMO", password: "CHOMPY12"}
  feature "login with tags overriding user defaults", %{session: session} do
    session
    |> visit(login_route())
    |> fill_form("BAMMO", "CHOMPY12")
    |> assert_has(Query.css(page_heading(), text: "Home"))
  end

  feature "login and redirect", %{session: session, user: user, raw_password: raw_password} do
    session
    |> visit(other_route())
    |> assert_has(login_form())
    |> fill_form(user.username, raw_password)
    |> assert_has(Query.css(page_heading(), text: "Other"))
  end

  @tag user: [roles: []]
  feature "failed login no roles", %{session: session, user: user, raw_password: raw_password} do
    session
    |> visit(login_route())
    |> assert_has(login_form())
    |> fill_form(user.username, raw_password)
    |> assert_login_failed()
  end

  feature "failed login invalid username", %{session: session} do
    session
    |> visit(login_route())
    |> fill_form("invalid", "whatever")
    |> assert_login_failed()
  end

  feature "failed login invalid password", %{session: session, user: user} do
    session
    |> visit(login_route())
    |> fill_form(user.username, "whatever")
    |> assert_login_failed()
  end

  @tag login: true
  feature "login automatically for tests", %{session: session} do
    session
    |> visit(home_route())
    |> assert_has(Query.css(page_heading(), text: "Home"))
  end

  # defp login_route, do: "/login"
  defp home_route, do: "/"
  defp other_route, do: "/other"
  defp login_form, do: Query.css("#login_form")

  defp assert_login_failed(session) do
    assert_has(session, Query.css(toast(), text: "Username or password is incorrect"))
  end

  defp fill_form(session, username, password) do
    session
    |> fill_in(Query.text_field("Username"), with: username)
    |> fill_in(Query.text_field("Password"), with: password)
    |> click(Query.button("Login"))
  end
end
