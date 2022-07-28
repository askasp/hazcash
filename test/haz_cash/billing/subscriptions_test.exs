defmodule HazCash.BillingTest do
  use HazCash.DataCase, async: true

  import HazCash.BillingFixtures

  alias HazCash.Billing.Subscriptions
  alias HazCash.Billing.Subscription

  def setup_customer_and_plan(_) do
    customer = customer_fixture()
    plan = plan_fixture()
    {:ok, customer: customer, plan: plan}
  end

  describe "subscriptions" do
    setup [:setup_customer_and_plan]

    @invalid_attrs %{cancel_at: nil, canceled_at: nil, current_period_end_at: nil, current_period_start: nil, status: nil, stripe_id: nil}

    test "paginate_subscriptions/1 returns paginated list of subscriptions" do
      for _ <- 1..20 do
        subscription_fixture()
      end

      {:ok, %{entries: subscriptions} = page} = Subscriptions.paginate_subscriptions(%{})

      assert length(subscriptions) == 15
      assert page.page_number == 1
      assert page.page_size == 15
      assert page.total_pages == 2
      assert page.total_entries == 20
      assert page.distance == 5
      assert page.sort_field == "inserted_at"
      assert page.sort_direction == "desc"
    end

    test "list_subscriptions/0 returns all subscriptions" do
      subscription = subscription_fixture()
      assert Subscriptions.list_subscriptions() == [subscription]
    end

    test "get_subscription!/1 returns the subscription with given id" do
      subscription = subscription_fixture()
      assert Subscriptions.get_subscription!(subscription.id) == subscription
    end

    test "get_subscription_by_stripe_id!/1 returns the subscription with given stripe_id" do
      subscription = subscription_fixture()
      assert Subscriptions.get_subscription_by_stripe_id!(subscription.stripe_id) == subscription
    end

    test "create_subscription/1 with valid data creates a subscription", %{customer: customer, plan: plan} do
      valid_attrs = %{cancel_at: ~N[2022-06-18 19:05:15], canceled_at: ~N[2022-06-18 19:05:15], current_period_end_at: ~N[2022-06-18 19:05:15], current_period_start: ~N[2022-06-18 19:05:15], status: "some status", stripe_id: "some stripe_id"}

      assert {:ok, %Subscription{} = subscription} = Subscriptions.create_subscription(customer, plan, valid_attrs)
      assert subscription.cancel_at == ~N[2022-06-18 19:05:15]
      assert subscription.canceled_at == ~N[2022-06-18 19:05:15]
      assert subscription.current_period_end_at == ~N[2022-06-18 19:05:15]
      assert subscription.current_period_start == ~N[2022-06-18 19:05:15]
      assert subscription.status == "some status"
      assert subscription.stripe_id == "some stripe_id"
    end

    test "create_subscription/1 with invalid data returns error changeset", %{customer: customer, plan: plan} do
      assert {:error, %Ecto.Changeset{}} = Subscriptions.create_subscription(customer, plan, @invalid_attrs)
    end

    test "update_subscription/2 with valid data updates the subscription", %{customer: customer} do
      subscription = subscription_fixture(customer)
      update_attrs = %{cancel_at: ~N[2022-07-18 19:05:15], canceled_at: ~N[2022-07-18 19:05:15], current_period_end_at: ~N[2022-07-18 19:05:15], current_period_start: ~N[2022-07-18 19:05:15], status: "some updated status", stripe_id: "some updated stripe_id"}

      assert {:ok, %Subscription{} = subscription} = Subscriptions.update_subscription(subscription, update_attrs)
      assert subscription.cancel_at == ~N[2022-07-18 19:05:15]
      assert subscription.canceled_at == ~N[2022-07-18 19:05:15]
      assert subscription.current_period_end_at == ~N[2022-07-18 19:05:15]
      assert subscription.current_period_start == ~N[2022-07-18 19:05:15]
      assert subscription.status == "some updated status"
      assert subscription.stripe_id == "some updated stripe_id"
    end

    test "update_subscription/2 with invalid data returns error changeset", %{customer: customer} do
      subscription = subscription_fixture(customer)
      assert {:error, %Ecto.Changeset{}} = Subscriptions.update_subscription(subscription, @invalid_attrs)
      assert subscription == Subscriptions.get_subscription!(subscription.id)
    end

    test "delete_subscription/1 deletes the subscription", %{customer: customer} do
      subscription = subscription_fixture(customer)
      assert {:ok, %Subscription{}} = Subscriptions.delete_subscription(subscription)
      assert_raise Ecto.NoResultsError, fn -> Subscriptions.get_subscription!(subscription.id) end
    end

    test "change_subscription/1 returns a subscription changeset" do
      subscription = subscription_fixture()
      assert %Ecto.Changeset{} = Subscriptions.change_subscription(subscription)
    end

    test "get_active_subscription_for_customer/1 returns an active subscription for a customer", %{customer: customer} do
      active_subscription_fixture(customer)
      assert %Subscription{} = Subscriptions.get_active_subscription_for_customer(customer)
    end

    test "get_active_subscription_for_customer/1 returns nil for a customer dont have an active subscription", %{customer: customer} do
      assert Subscriptions.get_active_subscription_for_customer(customer) == nil
    end
  end
end
