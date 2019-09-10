defmodule UnoxWeb.ClockLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <div>
    </div>
    """
  end

  def mount(_session, socket) do
    {:ok, socket}
  end

  def handle_info(:tick, socket) do
    {:noreply, socket}
  end
end
