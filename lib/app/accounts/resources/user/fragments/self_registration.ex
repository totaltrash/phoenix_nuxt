defmodule App.Accounts.User.Fragment.SelfRegistration do
  use Spark.Dsl.Fragment, of: Ash.Resource

  @moduledoc """
  A fragment to extract all the stuff we're not currently using in User which relates to self registration
  and self management (sending emails on email change, confirmations etc).

  Add it like `use Ash.Resource, fragments: [SelfRegistration]

  We've never used any of this stuff, so the first time you add it to an app, give it a good going over. And good luck.
  """

  alias App.Accounts.Preparations
  alias App.Accounts.User.Changes
  alias App.Accounts.User.Validations

  actions do
    read :with_verified_email_token do
      argument :token, :url_encoded_binary, allow_nil?: false
      argument :context, :string, allow_nil?: false

      prepare Preparations.SetHashedToken
      prepare Preparations.DetermineDaysForToken

      filter(
        expr do
          token.created_at > ago(^context(:days_for_token), :day) and
            token.token == ^context(:hashed_token) and token.context == ^arg(:context) and
            token.sent_to == email
        end
      )
    end

    update :deliver_user_confirmation_instructions do
      accept []

      argument :confirmation_url_fun, :function do
        constraints arity: 1
        allow_nil? false
      end

      validate attribute_equals(:confirmed_at, nil), message: "already confirmed"
      change Changes.CreateEmailConfirmationToken
    end

    update :deliver_update_email_instructions do
      accept [:email]

      argument :current_password, :string, allow_nil?: false

      argument :update_url_fun, :function do
        constraints arity: 1
        allow_nil? false
      end

      # validate validate_current_password(:current_password)
      validate {Validations.ValidateCurrentPassword, [field: :current_password]}
      validate changing(:email)

      change prevent_change(:email)
      change Changes.CreateEmailUpdateToken
    end

    update :deliver_user_reset_password_instructions do
      accept []

      argument :reset_password_url_fun, :function do
        constraints arity: 1
        allow_nil? false
      end

      change Changes.CreateResetPasswordToken
    end

    update :confirm do
      accept []
      argument :delete_confirm_tokens, :boolean, default: false

      change set_attribute(:confirmed_at, &DateTime.utc_now/0)
      change Changes.DeleteConfirmTokens
    end

    update :change_email do
      accept []
      argument :token, :url_encoded_binary

      change Changes.GetEmailFromToken
      change Changes.DeleteEmailChangeTokens
    end
  end
end
