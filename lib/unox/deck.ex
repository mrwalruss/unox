defmodule Unox.Deck do
  alias Unox.Card

  @colors ~w(yellow green blue red)a
  defmacro colors, do: @colors

  @wild_color :black
  defmacro wild_color, do: @wild_color

  @cards [
    {:colors, [0], 1},
    {:colors, [1, 2, 3, 4, 5, 6, 7, 8, 9, :skip, :switch, :plus_2], 2},
    {:special, [:plus_4, :any], 4}
  ]

  @spec new :: [Unox.Card.t()]
  def new() do
    @cards
    |> Enum.map(&create/1)
    |> List.flatten()
  end

  @spec shuffled :: [Unox.Card.t()]
  def shuffled(), do: Enum.shuffle(new())

  defp create({:colors, cards, count}) do
    cards
    |> Enum.map(&create_by_color/1)
    |> List.flatten()
    |> List.duplicate(count)
  end

  defp create({:special, cards, count}) do
    cards
    |> Enum.map(&(%Card{value: &1, color: wild_color()}))
    |> List.flatten()
    |> List.duplicate(count)
  end

  defp create_by_color(value) do
    colors()
    |> Enum.map(&(%Card{color: &1, value: value}))
    |> List.flatten()
  end

  @spec filter([Unox.Card.t()], {atom, atom}) :: [Unox.Card.t()]
  def filter(deck, card_spec), do: Enum.filter(deck, &Card.matches?(&1, card_spec))
end
