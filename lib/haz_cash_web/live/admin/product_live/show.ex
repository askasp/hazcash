defmodule HazCashWeb.Admin.ProductLive.Show do
  @moduledoc """
  The admin product show page.
  """
  use HazCashWeb, :live_view

  alias HazCash.Billing.Products

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    product = Products.get_product!(id)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:product, product)}
  end

  defp page_title(:show), do: "Show Product"
  defp page_title(:edit), do: "Edit Product"
end
