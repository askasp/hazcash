defmodule HazCashWeb.ExpenseAccountLiveTest do
  use HazCashWeb.ConnCase

  import Phoenix.LiveViewTest
  import HazCash.CoreFixtures

  @create_attrs %{name: "some name", priority: 42}
  @update_attrs %{name: "some updated name", priority: 43}
  @invalid_attrs %{name: nil, priority: nil}

  defp create_expense_account(_) do
    expense_account = expense_account_fixture()
    %{expense_account: expense_account}
  end

  describe "Index" do
    setup [:create_expense_account]

    test "lists all expense_accounts", %{conn: conn, expense_account: expense_account} do
      {:ok, _index_live, html} = live(conn, Routes.expense_account_index_path(conn, :index))

      assert html =~ "Listing Expense accounts"
      assert html =~ expense_account.name
    end

    test "saves new expense_account", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.expense_account_index_path(conn, :index))

      assert index_live |> element("a", "New Expense account") |> render_click() =~
               "New Expense account"

      assert_patch(index_live, Routes.expense_account_index_path(conn, :new))

      assert index_live
             |> form("#expense_account-form", expense_account: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#expense_account-form", expense_account: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.expense_account_index_path(conn, :index))

      assert html =~ "Expense account created successfully"
      assert html =~ "some name"
    end

    test "updates expense_account in listing", %{conn: conn, expense_account: expense_account} do
      {:ok, index_live, _html} = live(conn, Routes.expense_account_index_path(conn, :index))

      assert index_live |> element("#expense_account-#{expense_account.id} a", "Edit") |> render_click() =~
               "Edit Expense account"

      assert_patch(index_live, Routes.expense_account_index_path(conn, :edit, expense_account))

      assert index_live
             |> form("#expense_account-form", expense_account: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#expense_account-form", expense_account: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.expense_account_index_path(conn, :index))

      assert html =~ "Expense account updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes expense_account in listing", %{conn: conn, expense_account: expense_account} do
      {:ok, index_live, _html} = live(conn, Routes.expense_account_index_path(conn, :index))

      assert index_live |> element("#expense_account-#{expense_account.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#expense_account-#{expense_account.id}")
    end
  end

  describe "Show" do
    setup [:create_expense_account]

    test "displays expense_account", %{conn: conn, expense_account: expense_account} do
      {:ok, _show_live, html} = live(conn, Routes.expense_account_show_path(conn, :show, expense_account))

      assert html =~ "Show Expense account"
      assert html =~ expense_account.name
    end

    test "updates expense_account within modal", %{conn: conn, expense_account: expense_account} do
      {:ok, show_live, _html} = live(conn, Routes.expense_account_show_path(conn, :show, expense_account))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Expense account"

      assert_patch(show_live, Routes.expense_account_show_path(conn, :edit, expense_account))

      assert show_live
             |> form("#expense_account-form", expense_account: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#expense_account-form", expense_account: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.expense_account_show_path(conn, :show, expense_account))

      assert html =~ "Expense account updated successfully"
      assert html =~ "some updated name"
    end
  end
end
