defmodule MyAppWeb.HelloWorldLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    Message: <%= @message %>
    """
  end

  def mount(_session, socket) do
    {:ok, assign(socket, message: "Hello World!")}
  end
end
