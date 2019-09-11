defmodule UnoxWeb.LobbyView do
  use UnoxWeb, :view

  alias Unox.Game

  def render_players(players) do
    players
    |> Enum.map(&(&1.name))
    |> Enum.join(", ")
  end

  @tags ~w(join started creator turn)a
  def tags(game, player_id) do
    [{"blue", "Joined"}, {"red", "Started"}]
    Enum.reduce(@tags, [], fn tag, acc ->
      tag = tag(tag, game, player_id)
      if not is_nil(tag), do: [tag | acc], else: acc
    end)
  end

  @color "#1fec61"
  def tag(:join, game, player_id) do
    if Game.has_player?(game, player_id) do
      {@color, "Joined"}
    end
  end

  @color "#1f5eec"
  def tag(:started, %{started: true}, _), do: {@color, "Started"}

  @color "#ec951f"
  def tag(:creator, %{players: [%{id: player_id} | _]}, player_id), do: {@color, "Owner"}

  @color "#bf3030"
  def tag(:turn, %{started: true} = game, player_id) do
    if Game.current_player_is?(game, player_id) do
      {@color, "Your turn"}
    end
  end

  def tag(_, _, _), do: nil
end
