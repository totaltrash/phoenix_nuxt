defmodule Test.Browser.Admin.UserTest do
  use Test.BrowserCase

  feature "go to user admin", %{session: session} do
    session
    |> visit("/")
    |> click(Query.link("User Admin"))
    |> assert_has(Query.css("h1", text: "User Admin"))
  end

  feature "list all users", %{session: session} do
    insert_user(%{first_name: "Anne", surname: "User"})

    session
    |> visit("/admin/users")
    |> assert_has(Query.css("h1", text: "User Admin"))
    |> assert_text("Anne User")
  end
end
