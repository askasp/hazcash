defmodule HazCashWeb.ShowExpenseComponent do
  @moduledoc """
  The form for creating or editing a single product.
  """
  use HazCashWeb, :live_component

  @impl true
  def update(assigns, socket) do
  {:ok, assign(socket, assigns)}
  end
  
  def handle_event("update_expense", expenses, socket) do
  for {id, amount} <- expenses do
    # {amount,_ } = Integer.parse(expense.amount)
    Enum.find(socket.assigns.show_expenses, fn expense ->  expense.id == id end)
    |> IO.inspect
    |> HazCash.Core.update_expense(%{amount: amount})
  end

  {:noreply, push_redirect(socket, to: "/home")}
  end
  
  def render(assigns) do
  ~H"""
  <form phx-submit="update_expense" phx-target={@myself}>
  <%= for expense <- @show_expenses do %>   
  <div class="flex flex-auto justify-between mt-4 gap-2">
  <div>
<%= for label <- expense.labels do %>
    <div class=" badge badge-outline font-xs p-2 mt-1"><%= "#{label.key}: #{label.value}" %> </div>
 <% end %>
</div>

  <input type="number" name={expense.id} placeholder={expense.amount} value={expense.amount} class="font-mono text-right w-32 input input-bordered max-w-xs" />
</div>  
<% end %>


<div class="modal-action mt-5">
  <%= submit "Confirm", phx_disable_with: "Saving...", class: "ml-2 btn btn-primary" %>

</div>

</form> 
  """
  end
  

end
