defmodule Unox.Player do
  defstruct id: nil, name: nil, hand: [], password: nil
  alias Unox.{Player, Utils}

  @type new_user :: {String.t(), String.t()}
  @spec new([new_user]) :: [Unox.Player.t()]
  def new(names) when is_list(names), do: Enum.map(names, &new/1)

  @spec new(new_user) :: Unox.Player.t()
  def new({name, password}), do: %Player{id: Utils.id(), name: name, password: password}

  @spec new(String.t(), String.t()) :: Unox.Player.t()
  def new(id, name), do: %Player{id: id, name: name}

  @spec draw(Unox.Player.t(), [Unox.Card.t()]) :: Unox.Player.t()
  def draw(%Player{hand: hand} = player, cards) do
    %Player{player | hand: cards ++ hand}
  end

  @spec take_at(Unox.Player.t(), integer) :: Unox.Card.t()
  def take_at(%Player{hand: hand}, index), do: Enum.at(hand, index)

  @spec has_uno?(Unox.Player.t()) :: boolean
  def has_uno?(%Player{hand: [_]}), do: true
  def has_uno?(%Player{hand: _}), do: false

  @spec has_won?(Unox.Player.t()) :: boolean
  def has_won?(%Player{hand: []}), do: true
  def has_won?(%Player{hand: _}), do: false
end
