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
  def handle_in("action", _payload, socket) do
    # IO.inspect(payload)

    return = %{
      data: [
        %{id: "something", username: "auser", firstName: "Anne", surname: "User"}
      ]
    }

    {:reply, {:ok, return}, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
