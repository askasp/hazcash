defmodule HazCashWeb.ExpenseAccountLive.Show do
  use HazCashWeb, :live_view

  alias HazCash.Core

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:expense_account, Core.get_expense_account!(id))}
  end

  defp page_title(:show), do: "Show Expense account"
  defp page_title(:edit), do: "Edit Expense account"
end
