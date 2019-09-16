defmodule UnoxWeb.GameView do
  use UnoxWeb, :view
  import Unox.Deck, only: [colors: 0]
  alias Unox.{Card, Game, Player, Utils}

  @minimum_players 2

  def render_card(card, opts \\ []), do: UnoxWeb.CardView.render_card(card, opts)

  def render_hidden_card(opts \\ []), do: UnoxWeb.CardView.render_card(Card.hidden(), opts)

  @spec render_top_card(Unox.Game.t(), any) :: [any]
  def render_top_card(%Game{discards: discards}, opts \\ []) do
    discards
    |> Enum.take(3)
    |> Enum.reverse()
    |> Enum.map(&render_card(&1, opts))
  end

  def owner?(%Game{players: [%{id: id} | _]}, player_id), do: player_id == id

  def full?(game), do: Game.full?(game)

  def joined?(game, player_id), do: Game.has_player?(game, player_id)

  def startable?(%Game{players: players}), do: length(players) >= @minimum_players

  def is_playing?(%Game{players: players}, player_id),
    do: Enum.any?(players, &Utils.string_equals?(&1.id, player_id))

  def is_current_player?(game, player_id), do: Game.current_player_is?(game, player_id)

  def player_hand(game, player_id) do
    %Player{hand: hand} = get_player_by_id(game, player_id)

    Enum.with_index(hand)
  end

  def playable?(game, player_id, card) do
    Game.can_by_played?(game, card) and is_current_player?(game, player_id)
  end

  def needs_color?(game) do
    game
    |> Game.top_card()
    |> Card.is_black?()
  end

  def has_won?(game, player_id) do
    game
    |> get_player_by_id(player_id)
    |> Player.has_won?()
  end

  def can_set_color?(game, player_id),
    do: needs_color?(game) and is_current_player?(game, player_id)

  def player_item_class(%Game{} = game, player_id, current_player_id) do
    player = get_player_by_id(game, player_id)
    class = ["item"]

    class =
      if Utils.string_equals?(player_id, current_player_id), do: class ++ ["you"], else: class

    class =
      cond do
        Player.has_won?(player) and Game.ended?(game) -> class ++ ["winner"]
        is_current_player?(game, player_id) -> class ++ ["current"]
        true -> class
      end

    Enum.join(class, " ")
  end

  defp get_player_by_id(game, player_id),
    do: Enum.find(game.players, &Utils.string_equals?(&1.id, player_id))
end
