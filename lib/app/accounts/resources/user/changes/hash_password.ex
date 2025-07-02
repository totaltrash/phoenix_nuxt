defmodule App.Accounts.User.Changes.HashPassword do
  @moduledoc "A change that hashes the `password` attribute for valid changes"

  use Ash.Resource.Change

  def hash_password do
    {__MODULE__, []}
  end

  def init(_), do: {:ok, []}

  def change(changeset, _opts, _) do
    Ash.Changeset.before_action(changeset, fn changeset ->
      case Ash.Changeset.get_argument(changeset, :password) do
        nil ->
          changeset

        value ->
          Ash.Changeset.change_attribute(changeset, :hashed_password, Bcrypt.hash_pwd_salt(value))
      end
    end)
  end
end
