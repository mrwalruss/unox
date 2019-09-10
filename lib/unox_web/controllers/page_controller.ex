defmodule UnoxWeb.PageController do
  use UnoxWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
