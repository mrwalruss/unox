defmodule Unox.Utils do
  @spec remove([any], integer) :: {any, [any]}
  def remove(list, lookup_index) do
    list
    |> Enum.with_index()
    |> Enum.reduce({nil, []},
      fn {value, index}, {found, rest} ->
        if index == lookup_index do
          {value, rest}
        else
          {found, rest ++ [value]}
        end
    end)
  end

  @spec id :: binary
  def id(), do: Integer.to_string(:rand.uniform(4_294_967_296), 32) |> String.downcase()

  @spec to_int(binary | integer) :: integer
  def to_int(id) when is_integer(id), do: id
  def to_int(id) when is_bitstring(id) do
    {int, _} = Integer.parse(id)
    int
  end

  @spec string_equals?(String.t(), String.t()) :: boolean
  def string_equals?(first, second) do
    [first, second] = Enum.map([first, second], &string_safe/1)
    first == second
  end

  @spec string_safe(String.t()) :: String.t()
  def string_safe(str) do
    str
    |> String.trim()
    |> String.downcase()
  end

  @spec string_matches?(String.t(), String.t()) :: boolean
  def string_matches?(string, criteria) do
    [string, criteria] = Enum.map([string, criteria], &string_safe/1)
    String.contains?(string, criteria)
  end
end
