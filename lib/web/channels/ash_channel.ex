defmodule Web.AshChannel do
  use Web, :channel

  @impl true
  def join("ash", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in(
        "action",
        %{"domain" => domain, "actionName" => action_name, "params" => params} = _payload,
        socket
      ) do
    # IO.inspect(payload)

    # return = %{
    #   data: [
    #     %{id: "something", username: "auser", firstName: "Anne", surname: "User"}
    #   ]
    # }

    data = run_action(domain, action_name, params)

    # IO.inspect(Jason.encode!(data))

    return = %{
      data: data
    }

    {:reply, {:ok, return}, socket}
  end

  def run_action("accounts", "read_all_users", _params) do
    App.Accounts.read_all_users!()
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
