defmodule HazCashWeb.Admin.CustomerLive.Show do
  @moduledoc """
  The admin customer show page.
  """
  use HazCashWeb, :live_view

  alias HazCash.Billing.Customers

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    customer =
      Customers.get_customer!(id)
      |> Customers.with_subscriptions()

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:customer, customer)}
  end

  defp page_title(:show), do: "Show Customer"
end
