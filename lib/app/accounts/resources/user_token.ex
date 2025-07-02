defmodule App.Accounts.UserToken do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    notifiers: [App.Accounts.EmailNotifier],
    domain: App.Accounts

  alias App.Accounts.UserToken.Changes
  alias App.Accounts.Preparations

  postgres do
    table "user_token"
    repo App.Repo
  end

  identities do
    identity :token_context, [:context, :token]
  end

  actions do
    defaults([:destroy])

    read :read, primary?: true

    read :verify_email_token do
      argument :token, :url_encoded_binary, allow_nil?: false
      argument :context, :string, allow_nil?: false
      prepare Preparations.SetHashedToken
      prepare Preparations.DetermineDaysForToken

      filter(
        expr do
          token == ^context(:hashed_token) and context == ^arg(:context) and
            created_at > ago(^context(:days_for_token), :day)
        end
      )
    end

    create :create_session_token do
      primary? true
      accept []
      argument :user_id, :uuid, allow_nil?: false

      change manage_relationship(:user_id, :user, type: :append_and_remove)
      change set_attribute(:context, "session")
      change Changes.BuildSessionToken
    end

    create :build_email_token do
      accept [:sent_to, :context]

      change Changes.BuildHashedToken
    end
  end

  attributes do
    uuid_primary_key :id

    attribute :token, :binary
    attribute :context, :string
    attribute :sent_to, :string

    create_timestamp :created_at
  end

  relationships do
    belongs_to :user, App.Accounts.User, allow_nil?: false
  end
end
