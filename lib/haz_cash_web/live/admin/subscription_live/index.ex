defmodule HazCashWeb.Admin.SubscriptionLive.Index do
  @moduledoc """
  The admin subscriptions index page.
  """
  use HazCashWeb, :live_view
  import SaasKit.LiveComponents.DataTable

  alias HazCash.Billing.Subscriptions

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {
      :noreply,
      socket
      |> assign(:page_title, "Listing Subscriptions")
      |> assign(get_subscriptions_assigns(params))
      |> pagination_assigns()
      |> assign(:params, params)
    }
  end

  defp get_subscriptions_assigns(params) do
    case Subscriptions.paginate_subscriptions(params) do
      {:ok, assigns} -> assigns
      _ -> %{}
    end
  end
end
