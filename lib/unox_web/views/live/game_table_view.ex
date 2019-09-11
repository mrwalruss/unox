defmodule UnoxWeb.Live.GameTableView do
  use UnoxWeb, :live_view
  alias Unox.{Game, Player}
  alias UnoxWeb.{GameStore, PlayerStore}

  def render(%{game_id: game_id, game: game, player_id: player_id}) do
    UnoxWeb.GameView.render("table.html", %{game_id: game_id, game: game, player_id: player_id})
  end

  def mount(%{game_id: game_id, player_id: player_id}, socket) do
    socket =
      socket
      |> assign(:game_id, game_id)
      |> assign(:game, get_game(game_id))
      |> assign(:player_id, player_id)

    UnoxWeb.Endpoint.subscribe("game:#{game_id}")

    {:ok, socket}
  end

  def handle_event("start", _, socket) do
    mutate_game(socket, &Game.start/1)
    {:noreply, sync(socket)}
  end

  def handle_event("play", index, socket) do
    if can_play?(socket) do
      with {:ok, game} <- Game.play_at(get_game_from_socket(socket), index) do
        save(game)
        {:noreply, sync(socket)}
      else
        _ -> {:noreply, socket}
      end
    else
      {:noreply, socket}
    end
  end

  def handle_event("draw", _, socket) do
    if can_play?(socket) do
      mutate_game(socket, &(Game.player_draw(&1)))

      {:noreply, sync(socket)}
    else
      {:noreply, socket}
    end
  end

  def handle_event("set-color", color, socket) do
    if can_set_color?(socket) do
      mutate_game(socket, &(Game.set_color(&1, color)))

      {:noreply, sync(socket)}
    else
      {:noreply, socket}
    end
  end

  def handle_event("join", player_id, socket) do
    mutate_game(socket, &(add_player(&1, player_id)))
    {:noreply, sync(socket)}
  end

  defp add_player(game, player_id) do
    {:ok, %{id: id, name: name}} = get_player(player_id)
    player = Player.new(id, name)
    %Game{game | players: game.players ++ [player]}
  end

  defp mutate_game(socket, fun) do
    socket =
      socket
      |> get_game_from_socket()
      |> fun.()
      |> save()

    notify_lobby()
    socket
  end

  defp can_play?(%{assigns: %{player_id: player_id}} = socket) do
    color_set?(socket) and Game.current_player_is?(get_game_from_socket(socket), player_id)
  end

  defp can_set_color?(%{assigns: %{player_id: player_id}} = socket) do
    not color_set?(socket) and Game.current_player_is?(get_game_from_socket(socket), player_id)
  end

  defp color_set?(socket) do
    socket
    |> get_game_from_socket()
    |> Game.has_color?()
  end

  def handle_info(%{topic: "game:" <> id}, %{assigns: %{game_id: id}} = socket) do
    {:noreply, sync(socket)}
  end

  def handle_event(_, socket) do
    {:noreply, socket}
  end

  defp sync(socket) do
    assign(socket, :game, get_game_from_socket(socket))
  end

  defp get_player(player_id), do: PlayerStore.get(player_id)

  defp save(%{id: id} = game) do
    GameStore.save(game)
    UnoxWeb.Endpoint.broadcast("game:#{id}", "update", %{})
    game
  end

  defp get_game_from_socket(%{assigns: %{game_id: game_id}}), do: get_game(game_id)

  defp get_game(game_id) do
    {:ok, game} = GameStore.get(game_id)
    game
  end

  defp notify_lobby() do
    UnoxWeb.Endpoint.broadcast("lobby", "update", %{})
  end
end
