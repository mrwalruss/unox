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

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", UnoxWeb do
    pipe_through :browser

    get "/", PageController, :index
    live "/clock", ClockLive
  end
end
