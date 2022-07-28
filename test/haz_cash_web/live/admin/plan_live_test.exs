defmodule HazCashWeb.PlanLiveTest do
  use HazCashWeb.ConnCase

  import Phoenix.LiveViewTest
  import HazCash.BillingFixtures

  defp create_plan(_) do
    product = product_fixture()
    plan = plan_fixture(product)
    %{plan: plan, product: product}
  end

  setup :register_and_log_in_admin

  describe "Index" do
    setup [:create_plan]

    test "lists all plans", %{conn: conn, plan: plan, product: product} do
      {:ok, _index_live, html} = live(conn, Routes.admin_plan_index_path(conn, :index, product))

      assert html =~ "Plans"
      assert html =~ plan.name
    end
  end

  describe "Show" do
    setup [:create_plan]

    test "displays plan", %{conn: conn, plan: plan, product: product} do
      {:ok, _show_live, html} = live(conn, Routes.admin_plan_show_path(conn, :show, product.id, plan.id))

      assert html =~ "Show Plan"
      assert html =~ plan.name
    end
  end
end
