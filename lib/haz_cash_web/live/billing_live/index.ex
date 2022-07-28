defmodule HazCashWeb.BillingLive.Index do
  @moduledoc """
  The Billing info page. This Module requires that current_user
  and current_account is set before.

  This module assumes current_user has been set.
  """
  use HazCashWeb, :live_view

  alias HazCash.Billing
  alias HazCash.Billing.Invoices
  alias HazCash.Billing.SynchronizeCustomer

  @impl true
  def mount(_params, _session, socket) do
    billing_customer = get_billing_customer(socket.assigns.current_user)
    invoices = get_invoices(billing_customer)
    Process.send(self(), {:sync_customer, billing_customer}, [])

    {
      :ok,
      socket
      |> assign(:billing_customer, billing_customer)
      |> assign(:invoices, invoices)
    }
  end

  @impl true
  def handle_params(%{"sync" => "true"}, _url, socket) do
    Billing.SynchronizeSubscriptions.run()

    {:noreply, socket}
  end

  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_info({:sync_customer, billing_customer}, socket) do
    # Get the latest payment info from Stripe
    SynchronizeCustomer.run(billing_customer)
    billing_customer = get_billing_customer(socket.assigns.current_user)

    {:noreply, assign(socket, :billing_customer, billing_customer)}
  end

  defp get_billing_customer(current_user) do
    Billing.get_billing_customer_for_user(current_user)
  end

  defp get_invoices(billing_customer) do
    Invoices.list_invoices_for_billing_customer(billing_customer)
  end
end
