import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :app, App.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "playing_phx_nuxt_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: System.schedulers_online() * 2

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :app, Web.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "1ZBSab8T+wf3T3b5AqJAyqaLkNhL0kX6077k7tTNjN9nzcxSe/6JgeDIWmrUkc1h",
  server: true

# In test we don't send emails
config :app, App.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true

# Reduce number of rounds during test only
config :bcrypt_elixir, :log_rounds, 4

# Wallaby
config :wallaby,
  driver: Wallaby.Chrome,
  chromedriver: [headless: System.get_env("HEADLESS", "true") != "false"],
  js_logger: nil

config :app, :sandbox, Ecto.Adapters.SQL.Sandbox
