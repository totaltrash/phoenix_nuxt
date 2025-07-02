defmodule App.Accounts.Permissions do
  @moduledoc """
  Permissions Enum
  ================

  Roles vs Permissions
  --------------------

  Permissions are a higher level concern than roles. Permissions may be assessed using roles, but they could also
  use other information, like the presence of a related resource on a user.

  Permissions are assessed by the User resource, in the `authorize` action.
  """

  use Ash.Type.Enum, values: [:is_admin, :is_developer]
end
