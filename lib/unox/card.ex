defmodule Unox.Card do
  defstruct value: nil, color: nil
  alias Unox.Card

  @spec equals?(Unox.Card.t(), Unox.Card.t()) :: boolean
  def equals?(first, second), do: same_color?(first, second) and same_value?(first, second)

  @spec same_color?(Unox.Card.t(), Unox.Card.t()) :: boolean
  def same_color?(%Card{color: first}, %Card{color: second}), do: first == second

  @spec same_value?(Unox.Card.t(), Unox.Card.t()) :: boolean
  def same_value?(%Card{value: first}, %Card{value: second}), do: first == second

  @spec is_black?(Unox.Card.t()) :: boolean
  def is_black?(%Card{color: :black}), do: true
  def is_black?(%Card{}), do: false

  @spec has_color?(Unox.Card.t()) :: boolean
  def has_color?(card), do: not is_black?(card)

  @spec fits_on_top?(Unox.Card.t(), Unox.Card.t()) :: boolean
  def fits_on_top?(bottom, top) do
    cond do
      same_value?(bottom, top) -> true
      same_color?(bottom, top) -> true
      is_black?(top) -> true
      true -> false
    end
  end

  @type card_tuple :: {nil | atom, nil | atom | integer}
  @spec matches?(Unox.Card.t(), card_tuple) :: boolean
  def matches?(%Card{value: card_value, color: card_color}, {card_color, card_value}), do: true
  def matches?(%Card{color: card_color}, {card_color, nil}), do: true
  def matches?(%Card{value: card_value}, {nil, card_value}), do: true
  def matches?(_, _), do: false
end
