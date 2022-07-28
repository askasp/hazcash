defmodule HazCash.Billing.CreateCustomerWorkerTest do
  use HazCash.DataCase, async: true
  # This line might or might not be required. Uncomment if so.
  # use Oban.Testing, repo: HazCash.Repo

  import HazCash.UsersFixtures

  alias HazCash.Billing.Customers
  alias HazCash.Billing.CreateCustomerWorker

  describe "create customer worker" do
    test "calls the stripe service to create the customer and store stripe id on the customer" do
      user = user_fixture()
      customer = Customers.get_customer!(user.id)
      assert customer.stripe_id == nil

      assert :ok = perform_job(CreateCustomerWorker, %{"id" => customer.id})
      assert %{stripe_id: "" <> _} = Customers.get_customer!(customer.id)
    end
  end
end
