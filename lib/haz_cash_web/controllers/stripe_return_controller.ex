defmodule HazCashWeb.StripeReturnController do
  @moduledoc """
  This Controller is used when the customer is treurning from Stripe after have used
  Checkout or Customer Portal. Url is /return_from_stripe
  """
  use HazCashWeb, :controller

  import HazCash.Billing.StripeService
  import HazCash.Billing.Helpers, only: [decode_token: 1]

  alias HazCash.Billing.Customers
  alias HazCash.Billing.Plans
  alias HazCash.Billing.Subscriptions

  def new(conn, %{"t" => "success", "bp" => encoded_token} = _params) do
    case decode_token(encoded_token) do
      {:ok, customer_stripe_id} ->

        user_return_to = get_session(conn, :user_return_to) || Routes.billing_index_path(conn, :index)
        customer = Customers.get_customer_by_stripe_id!(customer_stripe_id)

        case stripe_service(:list_subscriptions, args: %{customer: customer.stripe_id, status: "active"}) do
          {:ok, %Stripe.List{data: [%Stripe.Subscription{plan: stripe_plan} = stripe_subscription|_]}} ->
            plan = Plans.get_plan_by_stripe_id!(stripe_plan.id)

            Subscriptions.create_subscription(customer, plan, %{
              stripe_id: stripe_subscription.id,
              status: stripe_subscription.status,
              current_period_end_at: unix_to_naive_datetime(stripe_subscription.current_period_end)
            })

          _ ->
            nil
        end

        conn
        |> put_flash(:success, "The subscription signup was completed")
        |> redirect(to: user_return_to)

      nil ->
        render(conn, "error.html")
    end
  end

  def new(conn, %{"t" => "cancel", "bp" => encoded_token} = _params) do
    case decode_token(encoded_token) do
      {:ok, _token} ->
        user_return_to = get_session(conn, :user_return_to) || Routes.billing_index_path(conn, :index)

        conn
        |> put_flash(:info, "The subscription signup was cancelled")
        |> redirect(to: user_return_to)

      nil ->
        render(conn, "error.html")
    end
  end

  defp unix_to_naive_datetime(nil), do: nil

  defp unix_to_naive_datetime(datetime_in_seconds) do
    datetime_in_seconds
    |> DateTime.from_unix!()
    |> DateTime.to_naive()
  end
end
