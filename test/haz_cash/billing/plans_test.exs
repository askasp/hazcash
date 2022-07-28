defmodule HazCash.Billing.PlansTest do
  use HazCash.DataCase, async: true

  import HazCash.BillingFixtures

  alias HazCash.Billing.Plans
  alias HazCash.Billing.Plan

  def setup_product(_) do
    product = product_fixture()
    {:ok, product: product}
  end

  describe "plans" do
    setup [:setup_product]

    alias HazCash.Billing.Plan

    import HazCash.BillingFixtures

    @invalid_attrs %{active: nil, amount: nil, currency: nil, interval: nil, interval_count: nil, name: nil, nickname: nil, stripe_id: nil, trial_period_days: nil, usage_type: nil}

    test "paginate_plans/1 returns paginated list of plans", %{product: product} do
      for _ <- 1..20 do
        plan_fixture(product)
      end

      {:ok, %{entries: plans} = page} = Plans.paginate_plans(product, %{})

      assert length(plans) == 15
      assert page.page_number == 1
      assert page.page_size == 15
      assert page.total_pages == 2
      assert page.total_entries == 20
      assert page.distance == 5
      assert page.sort_field == "inserted_at"
      assert page.sort_direction == "desc"
    end

    test "list_plans/0 returns all plans" do
      plan = plan_fixture()
      assert Plans.list_plans() == [plan]
    end

    test "get_plan!/1 returns the plan with given id", %{product: product} do
      plan = plan_fixture(product)
      assert Plans.get_plan!(product, plan.id) == plan
    end

    test "get_plan_by_stripe_id!/1 returns the plan with given stripe_id" do
      plan = plan_fixture()
      assert Plans.get_plan_by_stripe_id!(plan.stripe_id) == plan
    end

    test "create_plan/1 with valid data creates a plan", %{product: product} do
      valid_attrs = %{active: true, amount: 42, currency: "some currency", interval: "some interval", interval_count: 42, name: "some name", nickname: "some nickname", stripe_id: "some stripe_id", trial_period_days: 42, usage_type: "some usage_type"}

      assert {:ok, %Plan{} = plan} = Plans.create_plan(product, valid_attrs)
      assert plan.active == true
      assert plan.amount == 42
      assert plan.currency == "some currency"
      assert plan.interval == "some interval"
      assert plan.interval_count == 42
      assert plan.name == "some name"
      assert plan.nickname == "some nickname"
      assert plan.stripe_id == "some stripe_id"
      assert plan.trial_period_days == 42
      assert plan.usage_type == "some usage_type"
    end

    test "create_plan/1 with invalid data returns error changeset", %{product: product} do
      assert {:error, %Ecto.Changeset{}} = Plans.create_plan(product, @invalid_attrs)
    end

    test "update_plan/2 with valid data updates the plan", %{product: product} do
      plan = plan_fixture(product)
      update_attrs = %{active: false, amount: 43, currency: "some updated currency", interval: "some updated interval", interval_count: 43, name: "some updated name", nickname: "some updated nickname", stripe_id: "some updated stripe_id", trial_period_days: 43, usage_type: "some updated usage_type"}

      assert {:ok, %Plan{} = plan} = Plans.update_plan(plan, update_attrs)
      assert plan.active == false
      assert plan.amount == 43
      assert plan.currency == "some updated currency"
      assert plan.interval == "some updated interval"
      assert plan.interval_count == 43
      assert plan.name == "some updated name"
      assert plan.nickname == "some updated nickname"
      assert plan.stripe_id == "some updated stripe_id"
      assert plan.trial_period_days == 43
      assert plan.usage_type == "some updated usage_type"
    end

    test "update_plan/2 with invalid data returns error changeset", %{product: product} do
      plan = plan_fixture(product)
      assert {:error, %Ecto.Changeset{}} = Plans.update_plan(plan, @invalid_attrs)
      assert plan == Plans.get_plan!(product, plan.id)
    end

    test "delete_plan/1 deletes the plan", %{product: product} do
      plan = plan_fixture(product)
      assert {:ok, %Plan{}} = Plans.delete_plan(plan)
      assert_raise Ecto.NoResultsError, fn -> Plans.get_plan!(product, plan.id) end
    end

    test "change_plan/1 returns a plan changeset" do
      plan = plan_fixture()
      assert %Ecto.Changeset{} = Plans.change_plan(plan)
    end
  end
end
