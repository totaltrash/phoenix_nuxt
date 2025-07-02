defmodule App.Accounts.Session do
  use Ash.Resource, data_layer: Ash.DataLayer.Ets, domain: App.Accounts

  actions do
    defaults [:read, :destroy]

    create :create do
      accept [:session_id, :value]
    end

    update :update do
      accept [:value]
    end
  end

  attributes do
    attribute :session_id, :binary, primary_key?: true, allow_nil?: false
    attribute :value, :map, default: %{}
    create_timestamp :created_at
    update_timestamp :updated_at
  end
end
