defmodule HazCash.Billing.CustomersTest do
  use HazCash.DataCase

  import HazCash.BillingFixtures
  import HazCash.UsersFixtures
  import HazCash.AccountsFixtures

  alias HazCash.Billing.Customers
  alias HazCash.Billing.Customer

  describe "customers" do
    test "paginate_customers/1 returns paginated list of customers" do
      for _ <- 1..20 do
        customer_fixture()
      end

      {:ok, %{entries: customers} = page} = Customers.paginate_customers(%{})

      assert length(customers) == 15
      assert page.page_number == 1
      assert page.page_size == 15
      assert page.total_pages == 2
      assert page.total_entries == 20
      assert page.distance == 5
      assert page.sort_field == "inserted_at"
      assert page.sort_direction == "desc"
    end

    test "list_customers/0 returns all customers" do
      customer = customer_fixture()
      assert Customers.list_customers() == [customer]
    end

    test "get_billing_customer_for_account/1 returns the customer that is assigned to be the billing customer" do
      user = user_fixture()
      customer = customer_fixture(user)
      account = account_fixture()
      membership_fixture(account, user, %{billing_customer: true})
      assert Customers.get_billing_customer_for_account(account) == customer
    end

    test "get_billing_customer_for_user/1 returns the customer that corresponds to the user" do
      user = user_fixture()
      customer = customer_fixture(user)
      assert Customers.get_billing_customer_for_user(user) == customer
    end

    test "get_customer!/1 returns the customer with given id" do
      customer = customer_fixture()
      assert Customers.get_customer!(customer.id) == customer
    end

    test "get_customer_by_stripe_id!/1 returns the customer with given id" do
      customer = customer_fixture()
      assert Customers.get_customer_by_stripe_id!(customer.stripe_id) == customer
    end

    test "with_subscriptions/1 returns the customer with subscriptions preloaded" do
      customer = customer_fixture()
      subscription_fixture(customer)
      assert %Customer{subscriptions: [_|_]} = Customers.with_subscriptions(customer)
    end

    test "update_customer/2 with valid data updates the customer" do
      customer = customer_fixture()
      assert {:ok, %Customer{} = customer} = Customers.update_customer(customer, %{stripe_id: "some updated stripe_id"})
      assert customer.stripe_id == "some updated stripe_id"
    end

    test "update_customer/2 with invalid data returns error changeset" do
      customer = customer_fixture()
      assert {:error, %Ecto.Changeset{}} = Customers.update_customer(customer, %{stripe_id: nil})
      assert customer == Customers.get_customer!(customer.id)
    end

    test "delete_customer/1 deletes the customer" do
      customer = customer_fixture()
      assert {:ok, %Customer{}} = Customers.delete_customer(customer)
      assert_raise Ecto.NoResultsError, fn -> Customers.get_customer!(customer.id) end
    end

    test "change_customer/1 returns a customer changeset" do
      customer = customer_fixture()
      assert %Ecto.Changeset{} = Customers.change_customer(customer)
    end
  end
end
