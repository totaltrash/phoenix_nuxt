defmodule App.Accounts.User do
  use Ash.Resource, data_layer: AshPostgres.DataLayer, domain: App.Accounts

  @moduledoc """
  User resource.

  This is based on the Ash example with auth demo. The self registration actions have been removed
  into a separate `SelfRegistration` spark dsl fragment which can be added in when needed.
  """

  alias App.Accounts.Preparations
  alias App.Accounts.User.Preparations, as: UserPreparations
  alias App.Accounts.User.Changes
  alias App.Accounts.User.Validations

  postgres do
    table "user_account"
    repo App.Repo
  end

  identities do
    identity :unique_username, [:username], message: "Username already exists"
    identity :unique_email, [:email], message: "Email already exists"
  end

  actions do
    defaults [:destroy]

    action :has_role, :boolean do
      description "Low level check to see if the user has the given role - favour using authorize in the wild as it may contain other logic"
      argument :user, :struct, allow_nil?: false
      argument :role, App.Accounts.Roles, allow_nil?: false

      run fn input, _context ->
        case input.arguments.role do
          role -> {:ok, Enum.member?(input.arguments.user.roles, role)}
        end
      end
    end

    action :authorize, :boolean do
      description "Higher level check to see if the user is permitted - can contain more logic than a simple check of has_role"
      argument :user, :struct, allow_nil?: false
      argument :permission, App.Accounts.Permissions, allow_nil?: false

      run fn input, _context ->
        %{user: user, permission: permission} = input.arguments

        case permission do
          :is_admin ->
            App.Accounts.user_has_role(user, :admin)

          # :is_developer ->
          #   {:ok, user.username == Ash.CiString.new("dblack")}

          _ ->
            {:ok, false}
        end
      end
    end

    read :read do
      primary? true
      prepare build(sort: [username: :asc], load: [:full_name])
    end

    read :enabled do
      prepare build(sort: [surname: :asc, first_name: :asc], load: [:full_name])
      # filter expr(length(roles) > 0)
      filter expr(fragment("array_length(?, 1)", roles) > 0)
    end

    read :with_role do
      argument :role, :atom, allow_nil?: false
      prepare build(sort: [surname: :asc, first_name: :asc], load: [:full_name])
      filter expr(^arg(:role) in roles)
    end

    read :by_username_and_password do
      argument :username, :string, allow_nil?: false, sensitive?: true
      argument :password, :string, allow_nil?: false, sensitive?: true

      prepare UserPreparations.ValidatePassword
      prepare UserPreparations.HasRole
      prepare build(load: [:full_name])

      filter expr(username == ^arg(:username))
    end

    read :by_token do
      argument :token, :url_encoded_binary, allow_nil?: false
      argument :context, :string, allow_nil?: false
      prepare Preparations.DetermineDaysForToken
      prepare build(load: [:full_name])

      filter(
        expr do
          token.token == ^arg(:token) and token.context == ^arg(:context) and
            token.created_at > ago(^context(:days_for_token), :day)
        end
      )
    end

    create :create do
      accept [:username, :email, :first_name, :surname, :roles]

      primary? true

      argument :password, :string do
        allow_nil? false
        constraints max_length: 80, min_length: 8
      end

      argument :password_confirmation, :string do
        allow_nil? false
      end

      validate confirm(:password, :password_confirmation),
        message: "Password confirmation does not match"

      change Changes.HashPassword
    end

    update :update do
      accept [:username, :email, :first_name, :surname, :roles]
      primary? true
    end

    update :logout do
      accept []
      require_atomic? false
      change Changes.RemoveAllTokens
    end

    update :change_password do
      accept []
      require_atomic? false

      argument :password, :string,
        allow_nil?: false,
        constraints: [
          max_length: 80,
          min_length: 8
        ]

      argument :password_confirmation, :string, allow_nil?: false
      argument :current_password, :string

      validate confirm(:password, :password_confirmation),
        message: "Does not match your new password"

      # validate validate_current_password(:current_password)
      validate {Validations.ValidateCurrentPassword, [field: :current_password]}

      change Changes.HashPassword
      # change Changes.RemoveAllTokens
    end

    update :admin_change_password do
      require_atomic? false
      accept []

      argument :password, :string do
        allow_nil? false

        constraints(
          max_length: 80,
          min_length: 8
        )
      end

      argument :password_confirmation, :string, allow_nil?: false

      validate confirm(:password, :password_confirmation),
        message: "Does not match new password"

      change Changes.HashPassword
      # change Changes.RemoveAllTokens
    end
  end

  attributes do
    uuid_primary_key :id
    create_timestamp :created_at
    update_timestamp :updated_at

    attribute :username, :ci_string do
      allow_nil? false
      constraints max_length: 30
    end

    attribute :hashed_password, :string do
      sensitive? true
    end

    attribute :email, :ci_string do
      allow_nil? false
      constraints max_length: 160
    end

    attribute :first_name, :string do
      allow_nil? false
      constraints max_length: 50
    end

    attribute :surname, :string do
      allow_nil? false
      constraints max_length: 50
    end

    attribute :roles, {:array, App.Accounts.Roles} do
      allow_nil? false
      constraints nil_items?: false
    end
  end

  relationships do
    has_many :token, App.Accounts.UserToken do
      destination_attribute(:user_id)
    end
  end

  calculations do
    calculate :full_name, :string, concat([:first_name, :surname], " ")
  end

  aggregates do
    count :session_token_count, :token, filter: [context: "session"]
  end

  validations do
    validate match(:email, ~r/^[^\s]+@[^\s]+$/),
      message: "Must be in the format of an email address"
  end
end
