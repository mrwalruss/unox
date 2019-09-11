defmodule UnoxWeb.Router do
  use UnoxWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug Phoenix.LiveView.Flash
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :logged_in do
    plug UnoxWeb.LoadPlayer
  end

  scope "/", UnoxWeb do
    pipe_through :browser

    get "/login", LoginController, :index
    post "/login", LoginController, :login
  end

  scope "/", UnoxWeb do
    pipe_through [:browser, :logged_in]

    get "/", LobbyController, :index
    get "/new", LobbyController, :new
    post "/game", GameController, :create
    get "/game/:id", GameController, :index
    get "/logout", LoginController, :logout
  end
end
