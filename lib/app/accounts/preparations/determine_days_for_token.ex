defmodule App.Accounts.Preparations.DetermineDaysForToken do
  use Ash.Resource.Preparation

  def determine_days_for_token() do
    {__MODULE__, []}
  end

  def prepare(query, _opts, _) do
    Ash.Query.put_context(
      query,
      :days_for_token,
      App.Accounts.User.Helpers.days_for_token(Ash.Query.get_argument(query, :context))
    )
  end
end
