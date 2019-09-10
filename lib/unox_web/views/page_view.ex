defmodule UnoxWeb.PageView do
  use UnoxWeb, :view


  def render_card(card) do
    UnoxWeb.CardView.render_card(card, [])
  end
end
