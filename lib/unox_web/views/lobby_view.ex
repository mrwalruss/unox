defmodule UnoxWeb.LobbyView do
  use UnoxWeb, :view

  alias Unox.{Game, Player}

  def render_players(players) do
    players
    |> Enum.map(&render_player/1)
  end

  def render_player(%Player{hand: hand, name: name}) do
    ~E"""
    <span class="player <%= if length(hand) == 0, do: "has-won" %>"><%= name %></span> //
    """
  end

  @tags ~w(join state creator turn)a
  def tags(game, player_id) do
    Enum.reduce(@tags, [], fn tag, acc ->
      tag = tag(tag, game, player_id)
      if not is_nil(tag), do: [tag | acc], else: acc
    end)
  end

  @color "#1fec61"
  def tag(:join, game, player_id) do
    cond do
      is_owner?(game, player_id) ->
        {"#ec951f", "Joined"}

      Game.has_player?(game, player_id) ->
        {@color, "Joined"}

      true ->
        nil
    end
  end

  @color "#1f5eec"
  def tag(:state, %{state: :started}, _), do: {@color, "Started"}

  @color "#1fd2ec"
  def tag(:state, %{state: :ended}, _), do: {@color, "Ended"}

  @color "#bf3030"
  def tag(:turn, %{state: :started} = game, player_id) do
    if Game.current_player_is?(game, player_id) do
      {@color, "Your turn"}
    end
  end

  def tag(_, _, _), do: nil

  def is_owner?(%{players: [%{id: id} | _]}, player_id), do: player_id == id

  def has_won?(%Player{hand: hand}), do: length(hand) == 0
end
