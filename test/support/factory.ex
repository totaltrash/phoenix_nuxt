defmodule Test.Factory do
  import Ash.Seed
  # alias App.Demo
  alias App.Accounts

  # def insert_job(title, rest \\ %{}) do
  #   attr =
  #     %{
  #       content: "Some Content",
  #       job_type: :normal,
  #       accept_terms: true,
  #       job_date: Date.utc_today()
  #     }
  #     |> Map.merge(rest)
  #     |> Map.put(:title, title)

  #   seed!(Demo.Job, attr)
  # end

  def insert_user(attr \\ %{}) do
    # Was getting some failing tests because someuser12 matches someuser123
    # when looking for content on a page, so pad out the unique integer
    suffix =
      System.unique_integer([:positive])
      |> Integer.to_string()
      |> String.pad_leading(8, "0")

    attr =
      %{
        username: "some#{suffix}",
        email: "some#{suffix}@example.com",
        first_name: "First#{suffix}",
        surname: "Surname#{suffix}",
        password: "SomeP@ss#{suffix}",
        roles: [:user],
        with_raw_password: false
      }
      |> Map.merge(attr)

    attr = Map.put(attr, :hashed_password, Bcrypt.hash_pwd_salt(attr.password))

    user =
      Accounts.User
      |> seed!(attr)
      |> Ash.load!(:full_name)
      |> field_to_string(:email)
      |> field_to_string(:username)

    case attr.with_raw_password do
      true -> {user, attr.password}
      _ -> user
    end
  end

  def insert_user_token(attr \\ %{}) do
    attr = Map.merge(%{user: nil, context: "session"}, attr)

    case attr.context do
      "session" ->
        attr = %{
          context: attr.context,
          user_id: attr.user.id,
          token: :crypto.strong_rand_bytes(32)
        }

        seed!(Accounts.UserToken, attr)

      _ ->
        # I've never used this path in anger, so to be checked over and replaced with seed
        # if we ever need to support other token types (we're using it to populate some non
        # session tokens for testing what information gets shown to admins when viewing a
        # user's sessions)

        attr = %{
          context: attr.context,
          user_id: attr.user.id,
          token: :crypto.strong_rand_bytes(32)
        }

        seed!(Accounts.UserToken, attr)

        # attr = Enum.into(attr, %{user: nil, sent_to: "some@email.com"})

        # Accounts.UserToken
        # |> Ash.Changeset.for_create(:build_email_token, %{
        #   context: attr.context,
        #   sent_to: attr.sent_to
        # })
        # |> Ash.Changeset.manage_relationship(:user, attr.user, type: :append_and_remove)
        # |> Accounts.create!()
    end
  end

  # convert ci_string (and other string wrapper types) to string
  defp field_to_string(item, field) do
    Map.put(item, field, to_string(Map.get(item, field)))
  end
end
