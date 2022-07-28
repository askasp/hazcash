defmodule HazCashWeb.Admin.InitAssigns do
  @moduledoc """
  Ensures common `assigns` are applied to all LiveViews attaching this hook.
  """

  import Phoenix.LiveView
  alias HazCashWeb.Router.Helpers, as: Routes

  def on_mount(:require_product, %{"product_id" => product_id} = _params, _session, socket) do
    product = HazCash.Billing.Products.get_product!(product_id)
    {:cont, assign(socket, :product, product)}
  end

  def on_mount(:require_product, _params, _session, socket) do
    {:halt,
      socket
      |> put_flash(:error, "You need to pass in a product_id in the params")
      |> push_redirect(to: Routes.admin_dashboard_index_path(socket, :index))}
  end
end
