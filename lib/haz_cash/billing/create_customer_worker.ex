defmodule HazCash.Billing.CreateCustomerWorker do
  @moduledoc """
  The worker is called when a user has registered from the users context.
  """
  use Oban.Worker

  import HazCash.Billing.StripeService

  alias HazCash.Billing.Customers

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"id" => id}}) do
    customer = Customers.get_customer!(id)
    if is_nil(customer.stripe_id) do

      {:ok, %{id: stripe_id}} = stripe_service(:create_customer, args: %{email: customer.email})
      Customers.update_customer(customer, %{stripe_id: stripe_id})
    end

    :ok
  end
end
