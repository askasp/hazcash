defmodule HazCashWeb.ExpenseLiveTest do
  use HazCashWeb.ConnCase

  import Phoenix.LiveViewTest
  import HazCash.CoreFixtures

  @create_attrs %{amount: 42, description: "some description", month: "some month", year: "some year"}
  @update_attrs %{amount: 43, description: "some updated description", month: "some updated month", year: "some updated year"}
  @invalid_attrs %{amount: nil, description: nil, month: nil, year: nil}

  defp create_expense(_) do
    expense = expense_fixture()
    %{expense: expense}
  end

  describe "Index" do
    setup [:create_expense]

    test "lists all expense", %{conn: conn, expense: expense} do
      {:ok, _index_live, html} = live(conn, Routes.expense_index_path(conn, :index))

      assert html =~ "Listing Expense"
      assert html =~ expense.description
    end

    test "saves new expense", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.expense_index_path(conn, :index))

      assert index_live |> element("a", "New Expense") |> render_click() =~
               "New Expense"

      assert_patch(index_live, Routes.expense_index_path(conn, :new))

      assert index_live
             |> form("#expense-form", expense: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#expense-form", expense: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.expense_index_path(conn, :index))

      assert html =~ "Expense created successfully"
      assert html =~ "some description"
    end

    test "updates expense in listing", %{conn: conn, expense: expense} do
      {:ok, index_live, _html} = live(conn, Routes.expense_index_path(conn, :index))

      assert index_live |> element("#expense-#{expense.id} a", "Edit") |> render_click() =~
               "Edit Expense"

      assert_patch(index_live, Routes.expense_index_path(conn, :edit, expense))

      assert index_live
             |> form("#expense-form", expense: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#expense-form", expense: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.expense_index_path(conn, :index))

      assert html =~ "Expense updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes expense in listing", %{conn: conn, expense: expense} do
      {:ok, index_live, _html} = live(conn, Routes.expense_index_path(conn, :index))

      assert index_live |> element("#expense-#{expense.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#expense-#{expense.id}")
    end
  end

  describe "Show" do
    setup [:create_expense]

    test "displays expense", %{conn: conn, expense: expense} do
      {:ok, _show_live, html} = live(conn, Routes.expense_show_path(conn, :show, expense))

      assert html =~ "Show Expense"
      assert html =~ expense.description
    end

    test "updates expense within modal", %{conn: conn, expense: expense} do
      {:ok, show_live, _html} = live(conn, Routes.expense_show_path(conn, :show, expense))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Expense"

      assert_patch(show_live, Routes.expense_show_path(conn, :edit, expense))

      assert show_live
             |> form("#expense-form", expense: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#expense-form", expense: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.expense_show_path(conn, :show, expense))

      assert html =~ "Expense updated successfully"
      assert html =~ "some updated description"
    end
  end
end
