defmodule HazCashWeb.NewExpenseComponent do
  @moduledoc """
  The form for creating or editing a single product.
  """
  
  use HazCashWeb, :live_component
  alias HazCash.Core

  @impl true
  def update(assigns, socket) do
  {:ok, assign(socket, assigns) |> assign(:select, "Salary Expense") |> assign(:selected_labels, [])}
  end
  
  def handle_event("create_salary_expense", form, socket) do
  account = HazCash.Accounts.get_account!(socket.assigns.account_id)
  Core.create_salary_expense(account, form["yearly_amount"], form["employee_name"], to_string(form["start_month"]), to_string(form["end_month"]), "2022", "2022")
  {:noreply, push_redirect(socket, to: "/home")}
  end
  
  def handle_event("select_updated", %{"select" => select}, socket), do: {:noreply, assign(socket, :select, select)}
  
  def handle_event("select_label", %{"label_id" => label_id}, socket) do
  label = Core.get_label!(label_id)
  new_list = [label | Enum.filter(socket.assigns.selected_labels, fn l -> l.key != label.key end)]
  {:noreply, assign(socket, :selected_labels, new_list)}
  end
  
  def handle_event("remove_selected_label", %{"label_id" => label_id}, socket) do
  new_list = Enum.filter(socket.assigns.selected_labels, fn l -> l.id != label_id end)
  {:noreply, assign(socket, :selected_labels, new_list)}
  end
  
  
  def render(assigns) do
  ~H"""
  
  <div class="w-full">
  <form phx-change="select_updated" phx-target={@myself}> 
    <select name="select" class="select select-primary w-full max-w-xs">
  <option> Salary Expense</option>
  <option> Generic Expense </option>
  </select>  
  </form>
  
  <%= case @select do %>
    <%= "Salary Expense"  -> %>
  <form phx-submit="create_salary_expense" phx-target={@myself}>

  <div class="form-control w-full max-w-xs">
    <label class="label">
      <span class="label-text">Yearly amount</span>
    </label>
    <input value="500000" name="yearly_amount" type="number" placeholder="In NOK" class="input input-bordered w-full max-w-xs" />
    </div>
  
  <div class="form-control w-full max-w-xs">
    <label class="label">
      <span class="label-text">Employee full name</span>
    </label>
    <input value="Aksel Stadler" name="employee_name" type="text" placeholder="Aksel Stadler" class="input input-bordered w-full max-w-xs" />
    </div>  
  <div class="form-control w-full max-w-xs grid grid-cols-2 gap-4">
  <div>
    <label class="label">
      <span class="label-text">Start month</span>
    </label>
    <input value="1" name="start_month" type="number" placeholder="Aksel Stadler" class="input input-bordered w-full max-w-xs" />
    </div>
  
    <div>
    <label class="label">
      <span class="label-text">End month</span>
    </label>
    <input value="11" name="end_month" type="number" placeholder="Aksel Stadler" class="input input-bordered w-full max-w-xs" />
    </div>
  </div>
  <div class="form-control w-full max-w-xs grid grid-cols-2 gap-4">
  <div>
    <label class="label">
      <span class="label-text">Start year</span>
    </label>
    <input name="start_year" value="2022" type="number" placeholder="Aksel Stadler" class="input input-bordered w-full max-w-xs" />
    </div>
  
    <div>
    <label class="label">
      <span class="label-text">End year</span>
    </label>
    <input name="end_year" value="2022" type="number" placeholder="Aksel Stadler" class="input input-bordered w-full max-w-xs" />
    </div>
  </div>
  <input class="mt-4 mb-4 btn btn-primary" type="submit" value="Create"/>
  </form>
  
  <%= "Generic Expense" ->%>
  <form phx-submit="create_generic_expense"  phx-change="select_label"  phx-target={@myself}>


  <div class="form-control w-full max-w-xs grid grid-cols-2 gap-2">
  <div>
    <label class="label">
      <span class="label-text"> Monthly incl. VAT</span>
    </label>
    <input value="1000" name="monthly_amount" type="number" placeholder="In NOK" class="input input-bordered w-full max-w-xs" />
  </div>
      
  <div >
    <label class="label">
      <span class="label-text">VAT %</span>
    </label>
    <input  name="VAT" type="number" placeholder="15" class="input input-bordered w-full max-w-xs" />
  </div>  

  </div>
    
  <div class="form-control">
  
    <div class="w-full">
    <label class="label">
      <span class="label-text"> Selected Labels</span>
    </label>
  
    <%= for selected_label <- @selected_labels do %>
    
<div class="indicator">
  <button type="button" phx-target={@myself} phx-click="remove_selected_label" phx-value-label_id={selected_label.id} class="indicator-item badge badge-secondary badge-xs"> X </button>     
    
      <div class="badge badge-outline text-xs"> 
        <%= selected_label.key %>: <%= selected_label.value %> 
    </div>
    </div>
    <% end %>
    </div>
    </div>

  
  <div class="form-control">
    <label class="label">
      <span class="label-text"> Add Labels </span>
    </label>
    <select name="label_id" class="select select-primary w-full max-w-xs">
    <option> </option>
    <%= for label <- @labels do %>
      <option value={label.id} > <%= label.key %> : <%= label.value %></option>
    <% end %>
  </select>  
  </div>
    
    
  <div class="form-control w-full max-w-xs grid grid-cols-2 gap-4">
  <div>
    <label class="label">
      <span class="label-text">Start month</span>
    </label>
    <input value="1" name="start_month" type="number" placeholder="Aksel Stadler" class="input input-bordered w-full max-w-xs" />
    </div>
  
    <div>
    <label class="label">
      <span class="label-text">End month</span>
    </label>
    <input value="11" name="end_month" type="number" placeholder="Aksel Stadler" class="input input-bordered w-full max-w-xs" />
    </div>
  </div>
  <div class="form-control w-full max-w-xs grid grid-cols-2 gap-4">
  <div>
    <label class="label">
      <span class="label-text">Start year</span>
    </label>
    <input name="start_year" value="2022" type="number" placeholder="Aksel Stadler" class="input input-bordered w-full max-w-xs" />
    </div>
  
    <div>
    <label class="label">
      <span class="label-text">End year</span>
    </label>
    <input name="end_year" value="2022" type="number" placeholder="Aksel Stadler" class="input input-bordered w-full max-w-xs" />
    </div>
  </div>
  <input class="mt-4 mb-4 btn btn-primary" type="submit" value="Create"/>
  </form>
  <% end %>
 
  
  </div>
  
  
  """
  end
  

end
