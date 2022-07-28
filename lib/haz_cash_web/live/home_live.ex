defmodule HazCashWeb.HomeLive do
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
      
    acc = user.accounts |> Enum.at(1)
    Core.list_expenses(acc.id)
    
    base_expenses = Core.get_expenses(acc.id)
    expenses = Core.group_expenses_by(base_expenses, ["Expense Account"])
    labels = Core.list_labels(acc.id)
    label_keys = labels |> Enum.map(fn label -> label.key end)
    |> Enum.uniq
        
    {:ok, assign(socket, label_keys: label_keys, labels: labels, show_expenses: [],base_expenses: base_expenses, expenses: expenses, account_id: acc.id)}
  end
  
  def handle_params(params, _url, socket) do    
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}    
  end
  
  
  defp apply_action(socket, :expenses, %{"ids" => ids} = params) do
  ids = String.split(ids, ",")
  show_expenses = Core.get_expenses(socket.assigns.account_id, ids)
  |> Enum.map(fn exp -> HazCash.Repo.preload(exp, :labels, skip_account_id: true) end)
  assign(socket, show_expenses: show_expenses)
  end
  
  defp apply_action(socket, :new_expenses, params), do: socket
  
  def month_nr_to_name(nr) do
    case nr do
      "0"-> "January"
      "1"-> "February"
      "2"-> "March"
      "3"-> "April"
      "4"-> "May"
      "5"-> "June"
      "6"-> "July"
      "7"-> "August"
      "8"-> "September"
      "9"-> "October"
      "10"-> "November"
      "11"-> "December"
      end
  end
  
  defp apply_action(socket, _, params), do: socket
  
  
  def merge_expenses_for_month(expenses, month) do
    filter_expenses_on_month(expenses,month)
    |> Enum.map(fn expense -> expense.amount end)
    |> Enum.sum
  end
  
  def filter_expenses_on_month(expenses, month) when is_integer(month) do
    Enum.filter(expenses, fn expense -> expense.month == to_string(month) end)
  end

  def filter_expenses_on_month(expenses, month)  do
    Enum.filter(expenses, fn expense -> expense.month == month end)
  end
  
  def expenses_to_query_params(expenses) do
    expenses
    |> Enum.map(fn expense -> expense.id end)
    |> Enum.join(",")
  end
  
  def handle_event("show_expenses", %{"expenses" => expenses}, socket) do
  {:noreply, push_patch(socket, to: "/home/expenses/#{expenses}")}
  end
  
  def handle_event("update_filter", form, socket) do
  
  expenses = Core.group_expenses_by(socket.assigns.base_expenses, Map.keys(form))
    
  {:noreply, assign(socket, :expenses, expenses)}
  end
    
  
      
  def handle_event("populate_test_data", _, socket) do
    Core.auto_populate_test_data(socket.assigns.account_id)   
    
    base_expenses = Core.get_expenses(socket.assigns.account_id)

    expenses = Core.group_expenses_by(base_expenses, ["Expense Account", "Employee"])    
    {:noreply, assign(socket, base_expenses: base_expenses, expenses: expenses)}
    
  end

  def handle_event("delete_test_data", _, socket) do
    Core.delete_all_expenses(socket.assigns.account_id)
    
    base_expenses = Core.get_expenses(socket.assigns.account_id)
    expenses = Core.group_expenses_by(base_expenses, ["Expense Account", "Employee"])    
    {:noreply, assign(socket, base_expenses: base_expenses, expenses: expenses)}
  end
  
  def handle_event(event, data, socket) do
  IO.inspect "dat is"
  IO.inspect data
  IO.inspect "event is"
  IO.inspect event
  {:noreply, socket}
  end

end
