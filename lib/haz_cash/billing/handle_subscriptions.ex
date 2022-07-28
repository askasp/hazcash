defmodule HazCash.Billing.HandleSubscriptions do
  @moduledoc """
  This module is responsible for handling incoming data from Stripe
  and storing it in the database.

  Note that this will fail if the stripe customer doesnt exist in the database.
  This is by design. If the stripe customer is not stored, something has been
  wrong further up.
  """
  alias HazCash.Billing.Plans
  alias HazCash.Billing.Customers
  alias HazCash.Billing.Subscriptions

  defdelegate get_customer_by_stripe_id!(customer_stripe_id), to: Customers
  defdelegate get_plan_by_stripe_id!(plan_stripe_id), to: Plans
  defdelegate get_subscription_by_stripe_id!(subscription_stripe_id), to: Subscriptions

  def create_subscription(%{customer: customer_stripe_id, plan: %{id: plan_stripe_id}} = stripe_subscription) do
    customer = get_customer_by_stripe_id!(customer_stripe_id)
    plan = get_plan_by_stripe_id!(plan_stripe_id)

    Subscriptions.create_subscription(customer, plan, %{
      stripe_id: stripe_subscription.id,
      status: stripe_subscription.status,
      current_period_start: unix_to_naive_datetime(stripe_subscription.current_period_start),
      current_period_end_at: unix_to_naive_datetime(stripe_subscription.current_period_end)
    })
  end

  def update_subscription(%{id: stripe_id} = stripe_subscription) do
    subscription = get_subscription_by_stripe_id!(stripe_id)
    cancel_at = stripe_subscription.cancel_at || stripe_subscription.canceled_at
    canceled_at = stripe_subscription.canceled_at

    Subscriptions.update_subscription(subscription, %{
      status: stripe_subscription.status,
      cancel_at: unix_to_naive_datetime(cancel_at),
      canceled_at: unix_to_naive_datetime(canceled_at),
      current_period_start: unix_to_naive_datetime(stripe_subscription.current_period_start),
      current_period_end_at: unix_to_naive_datetime(stripe_subscription.current_period_end),
    })
  end

  defp unix_to_naive_datetime(nil), do: nil

  defp unix_to_naive_datetime(datetime_in_seconds) do
    datetime_in_seconds
    |> DateTime.from_unix!()
    |> DateTime.to_naive()
  end
end
