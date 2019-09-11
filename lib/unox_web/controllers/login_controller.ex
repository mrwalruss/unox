defmodule UnoxWeb.LoginController do
  use UnoxWeb, :controller
  alias UnoxWeb.PlayerStore

  @spec index(Plug.Conn.t(), any) :: Plug.Conn.t()
  def index(conn, _params) do
    render(conn, "index.html")
  end

  @spec login(Plug.Conn.t(), map) :: Plug.Conn.t()
  def login(conn, %{"name" => name, "password" => password}) do
    with {:ok, player} <- PlayerStore.get_or_create(name, password) do
      conn
      |> put_player(player)
      |> redirect(to: Routes.lobby_path(conn, :index))
    else
      _ ->
        conn
        |> put_flash(:error, gettext("Wrong password"))
        |> redirect(to: Routes.login_path(conn, :index))
    end
  end

  @spec logout(Plug.Conn.t(), any) :: Plug.Conn.t()
  def logout(conn, _) do
    conn
    |> clear_session()
    |> redirect(to: Routes.login_path(conn, :index))
  end
end
