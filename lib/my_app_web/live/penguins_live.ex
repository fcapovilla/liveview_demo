defmodule MyAppWeb.PenguinsLive do
  use Phoenix.LiveView

  @max_x 118
  @max_y 65
  @down 0
  @left 1
  @right 2
  @up 3

  def render(assigns) do
    ~L"""
    <div phx-keydown="move" phx-target="window" phx-throttle="75">
      <%= for penguin <- @penguins do %>
        <div style="width: 48px;height: 48px;position: absolute;
          background: url(images/penguin.png) <%= penguin.step * -48 + penguin.type * -144 %>px <%= penguin.dir * -48 %>px;
          left: <%= penguin.x * 7 %>px;
          top: <%= penguin.y * 7 %>px;">
          <div style="position: absolute;bottom: -20px;left: -20px;overflow: hidden;white-space: nowrap;">
            <%= penguin.name %>
          </div>
        </div>
      <% end %>
    </div>
    """
  end

  def mount(%{name: name}, socket) do
    state = %{
      name: name,
      x: :rand.uniform(@max_x) - 1,
      y: :rand.uniform(@max_y) - 1,
      type: :rand.uniform(4) - 1,
      dir: @down,
      step: 0
    }
    if connected?(socket) do
      Phoenix.PubSub.subscribe(MyApp.PubSub, "penguin-presence")
      MyAppWeb.Presence.track(self(), "penguin-presence", state.name, state)
    end
    {:ok, assign(socket, penguins: fetch_penguins(), state: state)}
  end

  def handle_event("move", %{"code" => code}, %{assigns: %{state: state}} = socket) do
    state = case code do
      "ArrowUp" -> %{state | y: state.y - 1, dir: @up, step: rem(state.step + 1, 2)}
      "ArrowDown" -> %{state | y: state.y + 1, dir: @down, step: rem(state.step + 1, 2)}
      "ArrowLeft" -> %{state | x: state.x - 1, dir: @left, step: rem(state.step + 1, 2)}
      "ArrowRight" -> %{state | x: state.x + 1, dir: @right, step: rem(state.step + 1, 2)}
      _ -> state
    end
    MyAppWeb.Presence.update(self(), "penguin-presence", state.name, state)
    {:noreply, assign(socket, state: state)}
  end

  def handle_info(%{event: "presence_diff"}, socket) do
    {:noreply, assign(socket, penguins: fetch_penguins())}
  end

  defp fetch_penguins do
    MyAppWeb.Presence.list("penguin-presence") |> Enum.map(fn {_, data} -> List.first(data[:metas]) end)
  end
end
