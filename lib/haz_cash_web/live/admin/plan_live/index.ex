defmodule HazCashWeb.Admin.PlanLive.Index do
  @moduledoc """
  The admin plans index page.
  """
  use HazCashWeb, :live_view
  import SaasKit.LiveComponents.DataTable

  alias HazCash.Billing.Plans

  on_mount {HazCashWeb.Admin.InitAssigns, :require_product}

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
      |> assign(:page_title, "Listing Plans")
      |> assign(get_plans_assigns(socket.assigns.product, params))
      |> pagination_assigns()
    }
  end

  defp get_plans_assigns(product, params) do
    case Plans.paginate_plans(product, params) do
      {:ok, assigns} -> assigns
      _ -> %{}
    end
  end
end
