defmodule Unox.Namer do
  @titles ~w(lumber punk machine specimen master dragon bacon random apprentice car jumbo bum kerosene pitatoo gorilla)
  @size 2

  @spec make :: binary
  def make() do
    @titles
    |> Enum.shuffle()
    |> Enum.take(@size)
    |> Enum.map(&Macro.camelize/1)
    |> Enum.join(" ")
  end
end
