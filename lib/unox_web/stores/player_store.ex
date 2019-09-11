defmodule UnoxWeb.PlayerStore do
  use UnoxWeb.Store
  alias Unox.{Player, Utils}

  def save(%{id: id, name: name, password: password}) do
    persist(id, %{id: id, name: name, password: password})
  end

  def get_or_create(name, password) do
    with {:ok, player} <- get_by(&has_name?(&1, name)) do
      if player.password == password do
        {:ok, player}
      else
        {:error, :unauthorized}
      end
    else
      _ ->
        player =
          {name, password}
          |> Player.new()
          |> save()

        {:ok, player}
    end
  end

  def has_name?(%{name: player_name}, name), do: Utils.string_equals?(player_name, name)
end
