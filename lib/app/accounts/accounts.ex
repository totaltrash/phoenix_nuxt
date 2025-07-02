defmodule App.Accounts do
  use Ash.Domain
  require Ash.CodeInterface

  resources do
    resource App.Accounts.User do
      define :get_user, action: :read, get_by: :id
      define :read_all_users, action: :read
      define :create_user, action: :create
      define :delete_user, action: :destroy
      define :user_has_role, action: :has_role, args: [:user, :role]
      define :authorize_user, action: :authorize, args: [:user, :permission]
    end

    resource App.Accounts.UserToken do
      define :create_session_token, action: :create_session_token, args: [:user_id]
      define :delete_token, action: :destroy
      define :get_token, action: :read, get_by: :id
    end

    resource App.Accounts.Session do
      define :get_session, action: :read, get_by: :session_id
      define :create_session, action: :create, args: [:session_id, :value]
      define :update_session, action: :update, args: [:value]
    end
  end
end
