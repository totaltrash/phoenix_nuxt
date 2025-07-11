defmodule App.Repo do
  use AshPostgres.Repo,
    otp_app: :app

  @impl true
  def installed_extensions do
    # Add extensions here, and the migration generator will install them.
    ["uuid-ossp", "citext", "ash-functions"]
  end

  # Don't open unnecessary transactions
  # will default to `false` in 4.0
  @impl true
  def prefer_transaction? do
    false
  end

  @impl true
  def min_pg_version do
    %Version{major: 17, minor: 0, patch: 0}
  end
end
