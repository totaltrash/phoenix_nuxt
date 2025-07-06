defmodule Test.Browser.HomeTest do
  use Test.BrowserCase

  feature "smoke", %{session: session} do
    session
    |> visit("/")
    |> assert_has(Query.css("h1", text: "Playing with Nuxt and Phoenix"))
    |> assert_has(Query.css("button", text: "Send Ping"))
    |> assert_has(Query.text("poke: hello from Nuxt", count: 0))
    |> click(Query.css("button", text: "Send Ping"))

    # :timer.sleep(120_000)

    # session
    |> assert_has(Query.text("poke: hello from Nuxt", count: 1))
  end

  feature "navigate between views", %{session: session} do
    session
    |> visit("/")
    |> assert_has(Query.css("h1", text: "Playing with Nuxt and Phoenix"))
    |> click(Query.link("Other"))
    |> assert_has(Query.css("h1", text: "Other"))
    |> click(Query.link("Index"))
    |> assert_has(Query.css("h1", text: "Playing with Nuxt and Phoenix"))
  end
end
