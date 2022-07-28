defmodule HazCash.Billing.SynchronizeCustomerTest do
  use HazCash.DataCase, async: true

  import HazCash.BillingFixtures

  alias HazCash.Billing.SynchronizeCustomer

  describe "run" do
    test "run/1 syncs payment method from stripe and stores it on the customer" do
      customer = customer_fixture()

      refute customer.card_last4 == "4242"
      assert {:ok, customer} = SynchronizeCustomer.run(customer)
      assert customer.card_last4 == "4242"
    end
  end
end
