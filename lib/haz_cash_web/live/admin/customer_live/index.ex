defmodule HazCashWeb.Admin.CustomerLive.Index do
  @moduledoc """
  The admin customers index page.
  """
  use HazCashWeb, :live_view
  import SaasKit.LiveComponents.DataTable

  alias HazCash.Billing.Customers

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
      |> assign(:page_title, "Listing Customers")
      |> assign(get_customers_assigns(params))
      |> pagination_assigns()
    }
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    customer = Customers.get_customer!(id)
    {:ok, _} = Customers.delete_customer(customer)

    {:noreply, assign(socket, get_customers_assigns(socket.assigns.params))}
  end

  defp get_customers_assigns(params) do
    case Customers.paginate_customers(params) do
      {:ok, assigns} -> assigns
      _ -> %{}
    end
  end
end
