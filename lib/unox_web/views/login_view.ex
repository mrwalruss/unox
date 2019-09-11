defmodule UnoxWeb.LoginView do
  use UnoxWeb, :view
  alias Unox.Namer

  @spec suggest_name :: binary
  def suggest_name(), do: Namer.make()
end
