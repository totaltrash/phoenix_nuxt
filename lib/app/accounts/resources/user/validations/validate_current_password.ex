defmodule App.Accounts.User.Validations.ValidateCurrentPassword do
  use Ash.Resource.Validation

  alias Ash.Error.Changes.InvalidAttribute

  @impl true
  def validate(changeset, opts, _) do
    password = Ash.Changeset.get_argument(changeset, opts[:field])

    if App.Accounts.User.Helpers.valid_password?(changeset.data, password) do
      :ok
    else
      {:error,
       InvalidAttribute.exception(
         field: opts[:field],
         message: "Does not match your current password"
       )}
    end
  end
end
