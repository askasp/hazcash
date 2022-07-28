defmodule HazCashWeb.StripeCustomerPortalSession do
  @moduledoc """
  This Controller is used when the customer accessing the Stripe Customer Portal.
  Make sure you have activated the Stripe Customer Portal in your Stripe settings.
  """
  use HazCashWeb, :controller

  alias HazCash.Billing

  def create(conn, _params) do
    customer = Billing.get_billing_customer_for_user(conn.assigns.current_user)
    return_url = Routes.billing_index_url(conn, :index, %{sync: true})

    case Stripe.BillingPortal.Session.create(%{
      customer: customer.stripe_id,
      return_url: return_url
    }) do
      {:ok, session} -> redirect(conn, external: session.url)
      _ -> redirect(conn, to: Routes.billing_index_path(conn, :index))
    end
  end
end
