defmodule UnoxWeb.LobbyController do
  use UnoxWeb, :controller
  alias UnoxWeb.GameStore

  def index(conn, _params) do
    render(conn, "index.html", %{
      games: GameStore.all(),
      player_id: current_player(conn).id
    })
  end

  def new(conn, _) do
    render(conn, "new.html")
  end
end
