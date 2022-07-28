defmodule HazCashWeb.Admin.PlanLive.Show do
  @moduledoc """
  The admin plan show page.
  """
  use HazCashWeb, :live_view

  alias HazCash.Billing.Plans

  on_mount {HazCashWeb.Admin.InitAssigns, :require_product}

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    plan = Plans.get_plan!(socket.assigns.product, id)

    {:noreply,
     socket
     |> assign(:page_title, "Show Plan")
     |> assign(:plan, plan)}
  end
end
