defmodule MyAppWeb.HelloWorldLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <div>Message: <%= @message %></div>
    <button phx-click="add_exclamation" phx-value-text="!!!">!!!</button>
    """
  end

  def mount(_session, socket) do
    Phoenix.PubSub.subscribe(MyApp.PubSub, "hello-world-topic")
    {:ok, assign(socket, message: "Hello WAQ!")}
  end

  def handle_event("add_exclamation", %{"text" => text}, socket) do
    message = socket.assigns.message <> text
    Phoenix.PubSub.broadcast(MyApp.PubSub, "hello-world-topic", %{message: message})
    {:noreply, assign(socket, message: message)}
  end

  def handle_info(%{message: message}, socket) do
    {:noreply, assign(socket, message: message)}
  end
end
