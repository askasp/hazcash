defmodule HazCashWeb.Admin.ProductLive.Index do
  @moduledoc """
  The admin products index page.
  """
  use HazCashWeb, :live_view
  import SaasKit.LiveComponents.DataTable

  alias HazCash.Billing.Products

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {
      :noreply,
      socket
      |> assign(:params, params)
      |> apply_action(socket.assigns.live_action, params)
    }
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Product")
    |> assign(:product, Products.get_product!(id))
  end

  defp apply_action(socket, :index, params) do
    socket
    |> assign(:page_title, "Listing Products")
    |> assign(:product, nil)
    |> assign(get_products_assigns(params))
    |> pagination_assigns()
    |> assign(:params, params)
  end

  defp get_products_assigns(params) do
    case Products.paginate_products(params) do
      {:ok, assigns} -> assigns
      _ -> %{}
    end
  end
end
