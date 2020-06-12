defmodule Unox.Game do
  defstruct id: nil,
            name: nil,
            players: [],
            direction: :forward,
            deck: [],
            discards: [],
            player_index: 0,
            state: :not_started

  @type t() :: %__MODULE__{}

  require Unox.Deck
  alias Unox.{Card, Deck, Effect, Game, Player, Utils}

  @initial_cards 7
  @maximum_players 10

  @spec new(String.t(), Unox.Player.t()) :: Unox.Game.t()
  def new(name, player),
    do: %Game{
      id: Utils.id(),
      name: name,
      deck: Deck.new(),
      players: [player]
    }

  @spec start(Unox.Game.t()) :: Unox.Game.t()
  def start(%Game{} = game) do
    %Game{game | state: :started}
    |> shuffle()
    |> pop_first_card()
    |> distribute()
    |> apply_effect()
  end

  @spec pop_first_card(Unox.Game.t()) :: Unox.Game.t()
  def pop_first_card(%Game{deck: [top | deck]} = game) do
    if can_be_first_card?(top) do
      game
      |> shuffle()
      |> pop_first_card()
    else
      %Game{game | deck: deck, discards: [top]}
    end
  end

  @spec started?(Unox.Game.t()) :: boolean
  def started?(%Game{state: state}), do: state == :started

  @spec ended?(Unox.Game.t()) :: boolean
  def ended?(%Game{state: state}), do: state == :ended

  @spec can_be_first_card?(Unox.Card.t()) :: boolean
  def can_be_first_card?(card), do: Card.is_black?(card)

  @spec shuffle(Unox.Game.t()) :: Unox.Game.t()
  def shuffle(%Game{deck: deck} = game) do
    %Game{game | deck: Enum.shuffle(deck)}
  end

  @spec add_player(Unox.Game.t(), Unox.Player.t()) :: Unox.Game.t()
  def add_player(%Game{players: players} = game, %Player{} = player) do
    %Game{game | players: players ++ [player]}
  end

  @spec top_card(Unox.Game.t()) :: Unox.Card.t()
  def top_card(%Game{discards: [top | _]}), do: top

  @spec reverse(Unox.Game.t()) :: Unox.Game.t()
  def reverse(%Game{direction: :forward} = game), do: %Game{game | direction: :backward}
  def reverse(%Game{direction: :backward} = game), do: %Game{game | direction: :forward}

  @spec can_by_played?(Unox.Game.t(), Unox.Card.t()) :: boolean
  def can_by_played?(%Game{discards: [top | _]}, card), do: Card.fits_on_top?(top, card)

  @spec rotate_player(Unox.Game.t()) :: Unox.Game.t()
  def rotate_player(
        %Game{player_index: player_index, players: players, direction: :forward} = game
      ) do
    player_index = player_index + 1

    next_player = if player_index < length(players), do: player_index, else: 0
    %Game{game | player_index: next_player}
  end

  def rotate_player(
        %Game{player_index: player_index, players: players, direction: :backward} = game
      ) do
    player_index = player_index - 1

    next_player = if player_index >= 0, do: player_index, else: length(players) - 1
    %Game{game | player_index: next_player}
  end

  @spec shuffle_discards(Unox.Game.t()) :: Unox.Game.t()
  def shuffle_discards(%Game{discards: discards} = game) do
    discards = Enum.shuffle(discards)

    %Game{game | deck: discards}
  end

  @spec play(Unox.Game.t(), Unox.Card.t()) :: {:error, :dont_fit} | {:ok, Unox.Game.t()}
  def play(%Game{discards: discards} = game, card) do
    if can_by_played?(game, card) do
      game = %Game{game | discards: [card | discards]}

      if has_color?(game) do
        {:ok, next_player(game)}
      else
        {:ok, game}
      end
    else
      {:error, :dont_fit}
    end
  end

  @spec apply_effect(Unox.Game.t()) :: Unox.Game.t()
  def apply_effect(game), do: Effect.handle(game)

  @spec next_player(Unox.Game.t()) :: Unox.Game.t()
  def next_player(game) do
    game
    |> rotate_player()
    |> apply_effect()
  end

  @spec play_at(Unox.Game.t(), binary | integer) :: {:error, :dont_fit} | {:ok, any}
  def play_at(game, card_index) do
    %Player{hand: hand} = current_player(game)
    {card, hand} = Utils.remove(hand, Utils.to_int(card_index))
    player = %Player{current_player(game) | hand: hand}
    new_game = update_current_player(game, fn _ -> player end)

    with {:ok, game} <- play(new_game, card) do
      {:ok, put_status(game)}
    else
      err -> err
    end
  end

  def put_status(%Game{players: players} = game) do
    if Enum.any?(players, &(length(&1.hand) == 0)) do
      %Game{game | state: :ended}
    else
      game
    end
  end

  @type player_mapper :: (Unox.Player.t() -> Unox.Player.t())
  @spec update_current_player(Unox.Game.t(), player_mapper) :: Unox.Game.t()
  def update_current_player(%Game{players: players, player_index: player_index} = game, func) do
    players =
      players
      |> Enum.with_index()
      |> Enum.map(fn {player, index} ->
        if index == player_index, do: func.(player), else: player
      end)

    %Game{game | players: players}
  end

  @spec current_player(Unox.Game.t()) :: Unox.Player.t()
  def current_player(%{players: players, player_index: player_index}),
    do: Enum.at(players, player_index)

  @spec current_player_is?(Unox.Game.t(), String.t()) :: boolean
  def current_player_is?(game, player_id) do
    %{id: id} = current_player(game)
    player_id == id
  end

  @spec full?(Unox.Game.t()) :: boolean
  def full?(%Game{players: players}), do: length(players) >= @maximum_players

  @spec has_player?(Unox.Game.t(), String.t()) :: boolean
  def has_player?(%Game{players: players}, player_id),
    do: Enum.any?(players, fn %{id: id} -> player_id == id end)

  @spec draw(Unox.Game.t()) :: {[Unox.Card.t()], Unox.Game.t()}
  def draw(%Game{deck: []} = game) do
    game
    |> shuffle_discards()
    |> draw()
  end

  def draw(%Game{deck: [top | deck]} = game) do
    {[top], %Game{game | deck: deck}}
  end

  @spec draw(Unox.Game.t(), integer) :: {[Unox.Card.t()], Unox.Game.t()}
  def draw(%Game{deck: deck} = game, count) do
    cards = Enum.take(deck, count)
    deck = Enum.slice(deck, count..-1)
    {cards, %Game{game | deck: deck}}
  end

  @spec player_draw(Unox.Game.t()) :: Unox.Game.t()
  def player_draw(%Game{} = game) do
    {card, game} = draw(game)

    game
    |> update_current_player(&Player.draw(&1, card))
    |> rotate_player()
  end

  @spec can_play?(Unox.Game.t(), Unox.Player.t()) :: boolean
  def can_play?(%Game{} = game, %Player{hand: hand}) do
    has_color?(game) and Enum.any?(hand, &can_by_played?(game, &1))
  end

  @spec set_color(Unox.Game.t(), binary | atom) :: Unox.Game.t()
  def set_color(game, color) when is_bitstring(color), do: set_color(game, String.to_atom(color))

  def set_color(%Game{discards: [top | cards]} = game, color) when color in Deck.colors() do
    %Game{game | discards: [%Card{top | color: color} | cards]}
    |> next_player()
  end

  def set_color(game, _color), do: game

  @spec has_color?(Unox.Game.t()) :: boolean
  def has_color?(game) do
    game
    |> Game.top_card()
    |> Card.has_color?()
  end

  @type player_reducer :: (Unox.Player.t(), Unox.Game.t() -> {Unox.Player.t(), Unox.Game.t()})
  @spec reduce_players(Unox.Game.t(), player_reducer) :: Unox.Game.t()
  def reduce_players(%Game{players: players} = game, func) do
    {players, game} =
      Enum.reduce(players, {[], game}, fn player, {players, game} ->
        {player, game} = func.(player, game)
        {players ++ [player], game}
      end)

    %Game{game | players: players}
  end

  @spec distribute(Unox.Game.t()) :: Unox.Game.t()
  def distribute(%Game{} = game) do
    reduce_players(game, fn player, game ->
      {cards, game} = draw(game, @initial_cards)
      player = Player.draw(player, cards)
      {player, game}
    end)
  end
end
