defmodule HazCashWeb.ExpenseLive.Index do
  use HazCashWeb, :live_view

  alias HazCash.Core
  alias HazCash.Core.Expense
  alias HazCash.Users
  import Ecto.Query

  @impl true
  def mount(_params, _session, socket) do
  
    user =
      socket.assigns.current_user
      |> Users.with_memberships()
      IO.inspect user
      
    acc = user.accounts |> Enum.at(1)
    IO.puts "expenses"
    Core.list_expenses(acc.id)
    |> IO.inspect
    
    
    {:ok, assign(socket, expenses: Core.list_expenses(acc.id), account_id: acc.id)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
  
    expense_accounts = HazCash.Repo.all(from( ea in HazCash.Core.ExpenseAccount , where: ea.account_id == ^socket.assigns.account_id, select: {ea.name, ea.priority, ea.id}), skip_account_id: true)
    |> Enum.map(fn {name, priority,id } -> {"#{name} (priority #{priority})", id} end)
  
    socket
    |> assign(:page_title, "Edit Expense")
    |> assign(:expense, Core.get_expense!(id))
    |> assign(:expense_accounts, expense_accounts )


  end

  defp apply_action(socket, :new, _params) do
  
    expense_accounts = HazCash.Repo.all(from( ea in HazCash.Core.ExpenseAccount , where: ea.account_id == ^socket.assigns.account_id, select: {ea.name, ea.priority, ea.id}), skip_account_id: true)
    |> Enum.map(fn {name, priority,id } -> {"#{name} (priority #{priority})", id} end)
    IO.inspect expense_accounts
  
    socket
    |> assign(:page_title, "New Expense")
    |> assign(:expense, %Expense{})
    |> assign(:expense_accounts, expense_accounts )

  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Expense")
    |> assign(:expense, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    expense = Core.get_expense!(id)
    {:ok, _} = Core.delete_expense(expense)

    {:noreply, assign(socket, :expenses, Core.list_expenses(socket.assigns.account_id))}
  end

end
