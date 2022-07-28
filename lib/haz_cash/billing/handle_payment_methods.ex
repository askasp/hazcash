defmodule HazCash.Billing.HandlePaymentMethods do
  @moduledoc """
  This module is reponsible for setting and removing the card data on the
  billing customer. This will be called from the webhook processor
  """
  alias HazCash.Billing.Customers

  defdelegate get_customer_by_stripe_id!(customer_stripe_id), to: Customers

  def add_card_info(%{customer: nil}), do: nil
  def add_card_info(%{customer: customer_stripe_id, card: card}) do
    customer = get_customer_by_stripe_id!(customer_stripe_id)

    Customers.update_customer(customer, %{
      card_brand: card.brand,
      card_last4: card.last4,
      card_exp_year: card.exp_year,
      card_exp_month: card.exp_month
    })
  end

  def remove_card_info(%{customer: nil}), do: nil
  def remove_card_info(%{customer: customer_stripe_id}) do
    customer = get_customer_by_stripe_id!(customer_stripe_id)

    Customers.update_customer(customer, %{
      card_brand: nil,
      card_last4: nil,
      card_exp_year: nil,
      card_exp_month: nil
    })
  end
end
