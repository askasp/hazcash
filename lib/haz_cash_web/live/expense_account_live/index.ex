defmodule HazCashWeb.ExpenseAccountLive.Index do
  use HazCashWeb, :live_view

  alias HazCash.Core
  alias HazCash.Users
  alias HazCash.Core.ExpenseAccount

  @impl true
  def mount(_params, %{"user_token" => user_token} = session, socket) do
    
    
    user =
      socket.assigns.current_user
      |> Users.with_memberships()
      
    IO.inspect user
    acc = user.accounts |> Enum.at(1)


    expense_accounts = Core.list_expense_accounts(acc.id)
    # expense_accounts = []

    {:ok, assign(socket, :expense_accounts, expense_accounts)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Expense account")
    |> assign(:expense_account, Core.get_expense_account!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Expense account")
    |> assign(:expense_account, %ExpenseAccount{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Expense accounts")
    |> assign(:expense_account, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    expense_account = Core.get_expense_account!(id)
    {:ok, _} = Core.delete_expense_account(expense_account)

    {:noreply, assign(socket, :expense_accounts, list_expense_accounts())}
  end

  defp list_expense_accounts do
    Core.list_expense_accounts()
  end
end
