defmodule HazCashWeb.Admin.CustomerLiveTest do
  use HazCashWeb.ConnCase

  import Phoenix.LiveViewTest
  import HazCash.BillingFixtures

  defp create_customer(_) do
    customer = customer_fixture()
    %{customer: customer}
  end

  setup :register_and_log_in_admin

  describe "Index" do
    setup [:create_customer]

    test "lists all customers", %{conn: conn, customer: customer} do
      {:ok, _index_live, html} = live(conn, Routes.admin_customer_index_path(conn, :index))

      assert html =~ "customers"
      assert html =~ customer.card_brand
    end
  end

  describe "Show" do
    setup [:create_customer]

    test "displays customer", %{conn: conn, customer: customer} do
      {:ok, _show_live, html} = live(conn, Routes.admin_customer_show_path(conn, :show, customer))

      assert html =~ "Show Customer"
      assert html =~ customer.card_brand
    end
  end
end
