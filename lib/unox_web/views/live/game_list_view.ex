defmodule UnoxWeb.Live.GameListView do
  use UnoxWeb, :live_view
  alias UnoxWeb.{Endpoint, GameStore, LobbyView}

  def render(assigns) do
    LobbyView.render("game_list.html", assigns)
  end

  def mount(%{player_id: player_id}, socket) do
    socket =
      socket
      |> assign(:games, [])
      |> assign(:search, "")
      |> assign(:player_id, player_id)

    send(self(), :update)
    Endpoint.subscribe("lobby")
    {:ok, socket}
  end

  def handle_event("search", value, socket) do
    send(self(), {:change, value})
    {:noreply, socket}
  end

  @spec handle_info(:update | {:change, map} | %{topic: <<_::40>>}, Phoenix.LiveView.Socket.t()) :: {:noreply, any}
  def handle_info(%{topic: "lobby"}, socket) do
    {:noreply, update(socket)}
  end

  def handle_info({:change, values}, socket) do
    socket = update_setting(values, socket)
    {:noreply, socket}
  end

  def handle_info(:update, socket) do
    socket = update(socket)
    {:noreply, socket}
  end

  def update_setting(%{"search" => search}, socket) do
    socket
    |> assign(:search, search)
    |> update()
  end

  def update(socket) do
    assign(socket, :games, get_games(socket.assigns))
  end

  def get_games(%{search: search}) do
    GameStore.all()
    |> Enum.filter(&game_matches_search(&1, search))
  end

  defp game_matches_search(%{name: name, players: players}, search) do
    cond do
      string_matches?(name, search) ->
        true

      Enum.any?(players, &(string_matches?(&1.name, search))) ->
        true

      true ->
        false
    end
  end
end
