defmodule UnoxWeb.LoadPlayer do
  import Plug.Conn
  import Phoenix.Controller
  alias UnoxWeb.Router.Helpers, as: Routes
  alias UnoxWeb.PlayerStore

  @spec init(any) :: nil
  def init(_) do
  end

  def call(conn, _) do
    with {:ok, id} <- fetch_session_key(conn),
         {:ok, player} <- fetch_player(id) do
      assign(conn, :player, player)
    else
      _ -> error(conn)
    end
  end

  def fetch_player(id), do: PlayerStore.get(id)

  def fetch_session_key(conn) do
    case get_session(conn, :id) do
      nil -> {:error, :not_found}
      id -> {:ok, id}
    end
  end

  def error(conn) do
    conn
    |> redirect(to: Routes.login_path(conn, :index))
    |> halt()
  end
end
