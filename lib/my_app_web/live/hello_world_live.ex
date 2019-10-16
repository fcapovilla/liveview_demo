defmodule MyAppWeb.HelloWorldLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <%= for message <- @messages do %>
      <div>Message: <%= message %></div>
    <% end %>
    <form phx-submit="say">
      <input type="text" name="message"/>
      <input type="submit">
    </form>
    """
  end

  def mount(_session, socket) do
    Phoenix.PubSub.subscribe(MyApp.PubSub, "chat-topic")
    {:ok, assign(socket, messages: [])}
  end

  def handle_event("say", %{"message" => message}, socket) do
    Phoenix.PubSub.broadcast(MyApp.PubSub, "chat-topic", %{message: message})
    {:noreply, socket}
  end

  def handle_info(%{message: message}, socket) do
    messages = socket.assigns.messages ++ [message]
    {:noreply, assign(socket, messages: messages)}
  end
end
