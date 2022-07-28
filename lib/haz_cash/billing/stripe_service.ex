defmodule HazCash.Billing.StripeService do
  @moduledoc """
  This module is an abstraction so in tests the MockStripe module can be used instead
  of hitting production Stripe.

      import HazCash.Billing.StripeService
  """
  defp test?, do: Application.get_env(:haz_cash, :env) == :test

  def stripe_service(name), do: stripe_service(name, [])

  def stripe_service(:list_plans, _opts) do
    if test?() do
      MockStripe.Plan.list()
    else
      Stripe.Plan.list()
    end
  end

  def stripe_service(:list_products, _opts) do
    if test?() do
      MockStripe.Product.list()
    else
      Stripe.Product.list()
    end
  end

  def stripe_service(:list_subscriptions, opts) do
    args = Keyword.get(opts, :args, %{})

    if test?() do
      {:ok, %{data: []}}
    else
      Stripe.Subscription.list(args)
    end
  end

  def stripe_service(:list_payment_methods, opts) do
    args = Keyword.get(opts, :args, %{})

    if test?() do
      case args do
        %{customer: "" <> customer_stripe_id} ->
          payment_method =
            %Stripe.PaymentMethod{
              card: %{
                brand: "visa",
                exp_month: 5,
                exp_year: 2035,
                last4: "4242",
              },
              customer: customer_stripe_id,
              type: "card"
            }
          {:ok, %{data: [payment_method]}}
        _ ->
          {:ok, %{data: []}}
      end
    else
      Stripe.PaymentMethod.list(args)
    end
  end

  def stripe_service(:webhook_construct_event, opts) do
    raw_body = Keyword.get(opts, :raw_body, %{})
    stripe_signature = Keyword.get(opts, :stripe_signature)
    webhook_signing_key = Keyword.get(opts, :webhook_signing_key)

    if test?() do
      MockStripe.Webhook.construct_event(raw_body, stripe_signature, webhook_signing_key)
    else
      Stripe.Webhook.construct_event(raw_body, stripe_signature, webhook_signing_key)
    end
  end

  def stripe_service(:create_customer, opts) do
    args = Keyword.get(opts, :args, %{})

    if test?() do
      MockStripe.Customer.create(args)
    else
      Stripe.Customer.create(args)
    end
  end
end
