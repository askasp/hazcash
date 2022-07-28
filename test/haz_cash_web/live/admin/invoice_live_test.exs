defmodule HazCashWeb.Admin.InvoiceLiveTest do
  use HazCashWeb.ConnCase

  import Phoenix.LiveViewTest
  import HazCash.BillingFixtures

  defp create_invoice(_) do
    invoice = invoice_fixture()
    %{invoice: invoice}
  end

  setup :register_and_log_in_admin

  describe "Index" do
    setup [:create_invoice]

    test "lists all invoices", %{conn: conn, invoice: invoice} do
      {:ok, _index_live, html} = live(conn, Routes.admin_invoice_index_path(conn, :index))

      assert html =~ "invoices"
      assert html =~ invoice.hosted_invoice_url
    end
  end
end
