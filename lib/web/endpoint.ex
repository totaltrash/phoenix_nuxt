defmodule Web.Endpoint do
  use Phoenix.Endpoint, otp_app: :app

  if sandbox = Application.compile_env(:app, :sandbox) do
    plug Phoenix.Ecto.SQL.Sandbox, sandbox: sandbox
  end

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  @session_options [
    store: :cookie,
    key: "_app_key",
    signing_salt: "OWm6Rzr5",
    same_site: "Lax"
  ]

  socket "/live", Phoenix.LiveView.Socket,
    websocket: [connect_info: [session: @session_options]],
    longpoll: [connect_info: [session: @session_options]]

  socket "/socket", Web.UserSocket,
    websocket: true,
    longpoll: false

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :app,
    gzip: false,
    only: Web.static_paths()

  # Start the nuxt client in test environment only, sometimes dev when debugging
  if Mix.env() in [:dev, :test] do
    plug Plug.Static,
      at: "/client_test",
      from: "client/.output/wallaby/public/"
  end

  # Enable CORS for dev environment only
  if Mix.env() == :dev do
    plug CORSPlug,
      origin: ["http://localhost:3000"],
      credentials: true
  end

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :app
  end

  plug Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options

  plug Web.Router
end
