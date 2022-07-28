defmodule HazCash.Billing.SynchronizeSubscriptions do
  @moduledoc """
  This module is responsible for getting data from Stripe
  and storing it in the database. It can be run manually or on a schedule.
  """
  import HazCash.Billing.StripeService
  import HazCash.Billing.HandleSubscriptions

  alias HazCash.Billing.Subscriptions

  defp get_all_subscriptions_from_stripe do
    {:ok, %{data: subscriptions}} = stripe_service(:list_subscriptions)
    subscriptions
  end

  def run do
    subscriptions_by_stripe_id =
      Subscriptions.list_subscriptions()
      |> Enum.group_by(& &1.stripe_id)

    get_all_subscriptions_from_stripe()
    |> Enum.map(fn stripe_subscription ->
      case Map.get(subscriptions_by_stripe_id, stripe_subscription.id) do
        nil ->
          create_subscription(stripe_subscription)

        [_existing_subscription] ->
          update_subscription(stripe_subscription)
      end
    end)
  end
end
