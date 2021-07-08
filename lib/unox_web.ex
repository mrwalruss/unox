defmodule UnoxWeb do
  def controller do
    quote do
      use Phoenix.Controller, namespace: UnoxWeb

      import Plug.Conn
      import UnoxWeb.Gettext
      alias UnoxWeb.Router.Helpers, as: Routes
      import Phoenix.LiveView.Controller, only: [live_render: 3]
      import UnoxWeb.Controller
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/unox_web/templates",
        namespace: UnoxWeb

      import Phoenix.Controller, only: [get_flash: 1, get_flash: 2, view_module: 1]

      use Phoenix.HTML

      import UnoxWeb.ErrorHelpers
      import UnoxWeb.Gettext
      import Phoenix.LiveView.Helpers
      alias UnoxWeb.Router.Helpers, as: Routes
      import UnoxWeb.Controller
      import UnoxWeb.View
      import Unox.Utils
    end
  end

  def live_view do
    quote do
      use Phoenix.LiveView
      import Unox.Utils
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import UnoxWeb.Gettext
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
