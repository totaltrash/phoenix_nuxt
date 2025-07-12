# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     App.Repo.insert!(%App.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

# USERS
App.Accounts.create_user!(%{
  username: "someuser",
  password: "SomeP@ss",
  password_confirmation: "SomeP@ss",
  email: "someuser@example.com",
  first_name: "Some",
  surname: "User",
  roles: [:admin, :user]
})
