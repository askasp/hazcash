defmodule HazCashWeb.Admin.ProductLiveTest do
  use HazCashWeb.ConnCase

  import Phoenix.LiveViewTest
  import HazCash.BillingFixtures

  @update_attrs %{local_description: "some updated local_description", local_name: "some updated local_name"}

  defp create_product(_) do
    product = product_fixture()
    %{product: product}
  end

  setup :register_and_log_in_admin

  describe "Index" do
    setup [:create_product]

    test "lists all products", %{conn: conn, product: product} do
      {:ok, _index_live, html} = live(conn, Routes.admin_product_index_path(conn, :index))

      assert html =~ "products"
      assert html =~ product.local_name
    end

    test "updates product in listing", %{conn: conn, product: product} do
      {:ok, index_live, _html} = live(conn, Routes.admin_product_index_path(conn, :index))

      assert index_live |> element("#product-#{product.id} a", "Edit") |> render_click() =~
               "Edit Product"

      assert_patch(index_live, Routes.admin_product_index_path(conn, :edit, product))

      {:ok, _, html} =
        index_live
        |> form("#product-form", product: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.admin_product_index_path(conn, :index))

      assert html =~ "Product updated successfully"
      assert html =~ "some updated local_name"
    end
  end

  describe "Show" do
    setup [:create_product]

    test "displays product", %{conn: conn, product: product} do
      {:ok, _show_live, html} = live(conn, Routes.admin_product_show_path(conn, :show, product))

      assert html =~ "Show Product"
      assert html =~ product.description
    end

    test "updates product within modal", %{conn: conn, product: product} do
      {:ok, show_live, _html} = live(conn, Routes.admin_product_show_path(conn, :show, product))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Product"

      assert_patch(show_live, Routes.admin_product_show_path(conn, :edit, product))

      {:ok, _, html} =
        show_live
        |> form("#product-form", product: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.admin_product_show_path(conn, :show, product))

      assert html =~ "Product updated successfully"
      assert html =~ "some updated local_name"
    end
  end
end
