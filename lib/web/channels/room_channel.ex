defmodule Web.RoomChannel do
  use Web, :channel

  @impl true
  def join("room:lobby", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("ping", payload, socket) do
    push(socket, "poke", %{msg: "👋 poke: #{payload["msg"]}"})
    {:reply, {:ok, payload}, socket}
  end

  def handle_in("poke", %{"msg" => msg}, socket) do
    IO.puts("POKING")
    push(socket, "poke", %{msg: "👋 poke: #{msg}"})
    {:noreply, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (room:lobby).
  @impl true
  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
