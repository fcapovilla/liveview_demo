defmodule MyAppWeb.HelloWorldLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <div>Message: <%= @message %></div>
    <button phx-click="add_exclamation" phx-value-text="!!!">!!!</button>
    """
  end

  def mount(_session, socket) do
    {:ok, assign(socket, message: "Hello World!")}
  end

  def handle_event("add_exclamation", %{"text" => text}, socket) do
    {:noreply, assign(socket, message: socket.assigns.message <> text)}
  end
end
