defmodule HazCashWeb.Admin.SubscriptionLiveTest do
  use HazCashWeb.ConnCase

  import Phoenix.LiveViewTest
  import HazCash.BillingFixtures

  defp create_subscription(_) do
    subscription = subscription_fixture()
    %{subscription: subscription}
  end

  setup :register_and_log_in_admin

  describe "Index" do
    setup [:create_subscription]

    test "lists all subscriptions", %{conn: conn, subscription: subscription} do
      {:ok, _index_live, html} = live(conn, Routes.admin_subscription_index_path(conn, :index))

      assert html =~ "subscriptions"
      assert html =~ subscription.status
    end
  end

  describe "Show" do
    setup [:create_subscription]

    test "displays subscription", %{conn: conn, subscription: subscription} do
      {:ok, _show_live, html} = live(conn, Routes.admin_subscription_show_path(conn, :show, subscription))

      assert html =~ "Show Subscription"
      assert html =~ subscription.status
    end
  end
end
