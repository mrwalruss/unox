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
end
