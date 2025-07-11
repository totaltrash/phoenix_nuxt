defmodule Test.Context do
  import Test.Factory

  def set_user_context(context, tags) do
    if tags[:user] == false do
      context
    else
      {user, raw_password} =
        if tags[:user] != nil do
          insert_user(Enum.into(tags[:user], %{with_raw_password: true}))
        else
          insert_user(%{with_raw_password: true})
        end

      context
      |> Map.put(:user, user)
      |> Map.put(:raw_password, raw_password)
    end
  end
end
