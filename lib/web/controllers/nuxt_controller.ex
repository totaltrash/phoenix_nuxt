defmodule Web.NuxtController do
  use Web, :controller

  @doc """
  Fallback controller for handling Nuxt client during browser testing
  """
  def index(conn, %{"path" => path_parts}) do
    path = Path.join(["client/.output/wallaby/public" | path_parts]) |> Path.join("index.html")

    if File.exists?(path) do
      conn
      |> put_resp_content_type("text/html")
      |> send_file(200, path)
    else
      send_resp(conn, 404, "Not Found")
    end
  end
end
