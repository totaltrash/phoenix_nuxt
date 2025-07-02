defmodule App.Accounts.Roles do
  @moduledoc """
  Roles Enum
  """
  @roles [admin: "Administrator", user: "User"]

  use Ash.Type.Enum, values: @roles

  def all_roles() do
    Enum.map(@roles, fn {label, key} -> {key, label} end)
  end

  def get_title(key) do
    Keyword.get(@roles, key, "Unknown Role")
  end

  @doc """
  Returns the list of titles for the given list of keys, or a string if join is provided
  """
  def get_titles(keys) do
    @roles
    |> Enum.filter(fn {key, _label} -> Enum.member?(keys, key) end)
    |> Enum.map(fn {_key, label} -> label end)
  end

  def get_titles(keys, join) do
    keys
    |> get_titles()
    |> Enum.join(join)
  end
end
