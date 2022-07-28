defmodule HazCashWeb.Admin.InvoiceLive.Index do
  @moduledoc """
  The admin invoices index page.
  """
  use HazCashWeb, :live_view
  import SaasKit.LiveComponents.DataTable

  alias HazCash.Billing.Invoices

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
      |> assign(:page_title, "Listing Invoices")
      |> assign(get_invoices_assigns(params))
      |> pagination_assigns()
    }
  end

  defp get_invoices_assigns(params) do
    case Invoices.paginate_invoices(params) do
      {:ok, assigns} -> assigns
      _ -> %{}
    end
  end
end
