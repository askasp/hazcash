defmodule HazCash.Billing do
  @moduledoc """
  The Billing context.
  """

  import Ecto.Query, warn: false
  alias HazCash.Repo
  alias HazCash.Billing.Customer
  alias HazCash.Billing.Customers
  alias HazCash.Billing.Subscription
  alias HazCash.Billing.Subscriptions
  alias HazCash.Billing.Plan

  defdelegate get_billing_customer_for_account(account), to: Customers
  defdelegate get_billing_customer_for_user(user), to: Customers
  defdelegate get_active_subscription_for_customer(customer), to: Subscriptions

  @doc """
  Gets a single active subscription for a account_id.

  Returns `nil` if an active Subscription does not exist.

  ## Examples

      iex> get_active_subscription_for_account(123)
      %Subscription{}

      iex> get_active_subscription_for_account(456)
      nil

  """
  def get_active_subscription_for_account(account) do
    with %Customer{} = customer <- get_billing_customer_for_account(account),
         %Subscription{} = subscription <- get_active_subscription_for_customer(customer) do
      subscription
    else
      _ ->
        nil
    end
  end

  def list_products_and_plans_for_pricing_page(interval \\ "month") do
    (
      from p in Plan,
      join: pr in assoc(p, :product),
      preload: [:product],
      where: pr.active == true,
      where: p.interval == ^interval,
      order_by: [:amount]
    )
    |> Repo.all()
  end
end
