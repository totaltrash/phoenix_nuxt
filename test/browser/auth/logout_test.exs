defmodule Test.Browser.Auth.LogoutTest do
  use Test.BrowserCase

  feature "successful logout", %{session: session} do
    session
    |> visit(home_route())
    # |> click(profile_button())
    |> assert_has(logout_button())
    |> click(logout_button())
    |> assert_has(login_form())
    |> visit(home_route())
    |> assert_has(login_form())
  end

  defp login_form, do: Query.css("#log_in_form")
  # defp profile_button, do: Query.css("#user-menu-button")
  defp logout_button, do: Query.button("Log out")
  defp home_route, do: "/"
end
