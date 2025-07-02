defmodule App.Accounts.User.Preparations.HasRole do
  use Ash.Resource.Preparation

  def prepare(query, _opts, _) do
    Ash.Query.after_action(query, fn
      _query, [result] ->
        case Enum.count(result.roles) do
          0 -> {:ok, []}
          _ -> {:ok, [result]}
        end

      _, _ ->
        {:ok, []}
    end)
  end
end
