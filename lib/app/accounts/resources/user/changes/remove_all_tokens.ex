defmodule App.Accounts.User.Changes.RemoveAllTokens do
  use Ash.Resource.Change
  require Ash.Query

  def remove_all_tokens, do: {__MODULE__, []}

  def change(changeset, _opts, _context) do
    Ash.Changeset.after_action(changeset, fn _changeset, user ->
      {:ok, query} =
        App.Accounts.UserToken
        |> Ash.Query.filter(token.user_id == ^user.id)
        |> Ash.Query.data_layer_query()

      App.Repo.delete_all(query)

      {:ok, user}
    end)
  end
end
