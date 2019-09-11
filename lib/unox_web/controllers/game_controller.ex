defmodule UnoxWeb.GameController do
  use UnoxWeb, :controller
  alias Unox.{Game, Player}
  alias UnoxWeb.GameStore

  def index(conn, %{"id" => id}) do
    with {:ok, game} <- GameStore.get(id) do
      render(conn, "index.html", %{game: game, player_id: current_player(conn).id})
    else
      _ -> redirect(conn, to: Routes.lobby_path(conn, :index))
    end
  end

  def create(conn, %{"name" => name}) do
    %{id: id, name: player_name} = current_player(conn)
    game = Game.new(name, Player.new(id, player_name))
    %Game{id: game_id} = GameStore.save(game)

    UnoxWeb.Endpoint.broadcast("lobby", "update", %{})
    redirect(conn, to: Routes.game_path(conn, :index, game_id))
  end
end
