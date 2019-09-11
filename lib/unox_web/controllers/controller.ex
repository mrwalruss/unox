defmodule UnoxWeb.Controller do
  import Plug.Conn

  def current_player(%{assigns: %{player: player}}), do: player
  def current_player(_), do: nil

  def put_player(conn, %{id: id}), do: put_session(conn, :id, id)
end
