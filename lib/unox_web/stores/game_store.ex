defmodule UnoxWeb.GameStore do
  use UnoxWeb.Store
  alias Unox.Game

  def save(%Game{id: id} = game) do
    persist(id, game)
  end
end
