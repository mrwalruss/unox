defmodule Unox.Utils do
  def id(), do: Integer.to_string(:rand.uniform(4_294_967_296), 32) |> String.downcase()
end
