defmodule Unox.Effect do
  import Unox.Game
  alias Unox.{Card, Game, Player}

  @spec handle(Unox.Game.t()) :: Unox.Game.t()
  def handle(%Game{discards: []} = game), do: game

  def handle(%Game{discards: [card | _]} = game), do: handle(game, card)

  @spec handle(Unox.Game.t(), Unox.Card.t()) :: Unox.Game.t()
  defp handle(game, %Card{value: :skip}), do: rotate_player(game)

  defp handle(%Game{players: players} = game, %Card{value: :switch})
       when length(players) > 2 do
    game
    |> reverse()
    |> rotate_player()
    |> rotate_player()
  end

  defp handle(game, %Card{value: :switch}), do: rotate_player(game)

  defp handle(game, %Card{value: :plus_2}) do
    {cards, game} = draw(game, 2)

    game
    |> update_current_player(&Player.draw(&1, cards))
    |> rotate_player()
  end

  defp handle(game, %Card{value: :plus_4}) do
    {cards, game} = draw(game, 4)

    game
    |> update_current_player(&Player.draw(&1, cards))
    |> rotate_player()
  end

  defp handle(game, _), do: game
end
