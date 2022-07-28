defmodule HazCash.Billing.SynchronizeCustomer do
  @moduledoc """
  This module is responsible for getting data from Stripe
  and storing it in the database. It can be run manually or on a schedule.
  """
  import HazCash.Billing.StripeService

  alias HazCash.Billing.HandlePaymentMethods

  alias HazCash.Billing.Customer

  def run(%Customer{} = customer) do
    sync_payment_method(customer)
  end

  def sync_payment_method(%{stripe_id: stripe_id} = _customer) do
    case stripe_service(:list_payment_methods, args: %{customer: stripe_id, type: "card"}) do
      {:ok, %{data: [payment_method|_]}} -> HandlePaymentMethods.add_card_info(payment_method)
      {:ok, %{data: []}} -> HandlePaymentMethods.remove_card_info(%{customer: stripe_id})
      _ -> nil
    end
  end
end
