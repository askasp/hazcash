defmodule HazCash.Billing.SynchronizePlansTest do
  use HazCash.DataCase

  import HazCash.BillingFixtures

  alias HazCash.Billing.Plans
  alias HazCash.Billing.SynchronizePlans

  def create_product(_) do
    product =
      product_fixture(%{
        name: "Standard Product",
        stripe_id: "prod_I2TE8siyANz84p"
      })

    %{product: product}
  end

  describe "run" do
    setup [:create_product]

    test "run/0 syncs plans from stripe and creates them in billing_plans" do
      assert Plans.list_plans() == []

      SynchronizePlans.run()
      assert [%HazCash.Billing.Plan{}] = Plans.list_plans()
    end

    test "run/0 deletes plans that exists in local database but does not exists in stripe", %{product: product} do
      {:ok, plan} =
        Plans.create_plan(product, %{
          name: "Dont exists",
          stripe_id: "price_abc123def456",
          amount: 666
        })

      assert [%{id: id} = _plan] = Plans.list_plans()
      assert id == plan.id

      SynchronizePlans.run()
      assert_raise Ecto.NoResultsError, fn -> Plans.get_plan!(product, plan.id) end
    end
  end
end
