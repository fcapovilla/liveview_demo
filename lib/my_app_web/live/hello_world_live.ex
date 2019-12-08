defmodule MyAppWeb.HelloWorldLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <%= for message <- @messages do %>
      <div><%= message %></div>
    <% end %>
    <form phx-submit="say">
      <input type="text" name="message"/>
      <input type="submit">
    </form>
    """
  end

  def mount(%{name: name}, socket) do
    Phoenix.PubSub.subscribe(MyApp.PubSub, "chat-topic")
    {:ok, assign(socket, messages: [], name: name)}
  end

  def handle_event("say", %{"message" => message}, %{assigns: %{name: name}} = socket) do
    Phoenix.PubSub.broadcast(MyApp.PubSub, "chat-topic", %{message: name <> ": " <> message})
    {:noreply, socket}
  end

  def handle_info(%{message: message}, socket) do
    messages = socket.assigns.messages ++ [message]
    {:noreply, assign(socket, messages: messages)}
  end
end
