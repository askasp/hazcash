defmodule HazCash.BillingFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `HazCash.Billing` context.
  """

  import HazCash.UsersFixtures

  alias HazCash.Users.User
  alias HazCash.Billing.Customer
  alias HazCash.Billing.Customers
  alias HazCash.Billing.Product
  alias HazCash.Billing.Products
  alias HazCash.Billing.Plans
  alias HazCash.Billing.Subscriptions
  alias HazCash.Billing.Invoices

  def unique_stripe_id, do: "foo_#{MockStripe.token()}"

  @doc """
  Generate a customer.
  """
  def customer_fixture(), do: customer_fixture(%{})
  def customer_fixture(%User{} = user), do: customer_fixture(user, %{})

  def customer_fixture(attrs) do
    user = user_fixture()
    customer_fixture(user, attrs)
  end

  def customer_fixture(user, attrs) do
    customer = Customers.get_customer!(user.id)

    attrs =
      Enum.into(attrs, %{
        card_brand: "visa",
        card_exp_month: 12,
        card_exp_year: 27,
        card_last4: "123",
        stripe_id: unique_stripe_id()
      })

    {:ok, customer} = Customers.update_customer(customer, attrs)

    Customers.get_customer!(customer.id)
  end

  @doc """
  Generate a product.
  """
  def product_fixture(attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        active: true,
        description: "some description",
        local_description: "some local_description",
        local_name: "some local_name",
        name: "some name",
        stripe_id: unique_stripe_id()
      })

    {:ok, product} = Products.create_product(attrs)

    Products.get_product!(product.id)
  end

  @doc """
  Generate a plan.
  """
  def plan_fixture(), do: plan_fixture(%{})
  def plan_fixture(%Product{} = product), do: plan_fixture(product, %{})

  def plan_fixture(attrs) do
    product = product_fixture()
    plan_fixture(product, attrs)
  end

  def plan_fixture(%Product{} = product, attrs) do
    attrs =
      Enum.into(attrs, %{
        active: true,
        amount: 42,
        currency: "some currency",
        interval: "some interval",
        interval_count: 42,
        name: "some name",
        nickname: "some nickname",
        stripe_id: unique_stripe_id(),
        trial_period_days: 42,
        usage_type: "some usage_type"
      })

    {:ok, plan} = Plans.create_plan(product, attrs)

    Plans.get_plan!(product, plan.id)
  end

  @doc """
  Generate a subscription.
  """
  def subscription_fixture(), do: subscription_fixture(%{})

  def subscription_fixture(%Customer{} = customer) do
    subscription_fixture(customer, plan_fixture(), %{})
  end

  def subscription_fixture(attrs) do
    plan = plan_fixture()
    customer = customer_fixture()

    subscription_fixture(customer, plan, attrs)
  end

  def subscription_fixture(%Customer{} = customer, plan, attrs) do
    attrs =
      Enum.into(attrs, %{
        cancel_at: ~N[2022-06-18 19:08:51],
        canceled_at: ~N[2022-06-18 19:08:51],
        current_period_end_at: ~N[2022-06-18 19:08:51],
        current_period_start: ~N[2022-06-18 19:08:51],
        status: "active",
        stripe_id: unique_stripe_id()
      })

    {:ok, subscription} = Subscriptions.create_subscription(customer, plan, attrs)

    Subscriptions.get_subscription!(subscription.id)
  end

  def active_subscription_fixture() do
    active_subscription_fixture(customer_fixture(), plan_fixture())
  end

  def active_subscription_fixture(%Customer{} = customer) do
    active_subscription_fixture(customer, plan_fixture())
  end

  def active_subscription_fixture(customer, plan) do
    time = NaiveDateTime.utc_now |> NaiveDateTime.add(3_600)
    attrs = %{status: "active", current_period_end_at: time, canceled_at: nil, cancel_at: nil}
    subscription_fixture(customer, plan, attrs)
  end

  @doc """
  Generate a invoice.
  """
  def invoice_fixture(), do: invoice_fixture(%{})

  def invoice_fixture(%Customer{} = customer) do
    invoice_fixture(customer, %{})
  end

  def invoice_fixture(attrs) do
    customer = customer_fixture()
    invoice_fixture(customer, attrs)
  end

  def invoice_fixture(%Customer{} = customer, attrs) do
    attrs =
      Enum.into(attrs, %{
        hosted_invoice_url: "some hosted_invoice_url",
        invoice_pdf: "some invoice_pdf",
        status: "some status",
        stripe_id: unique_stripe_id(),
        subtotal: 42
      })

    {:ok, invoice} = Invoices.create_invoice(customer, attrs)

    Invoices.get_invoice!(invoice.id)
  end
end
