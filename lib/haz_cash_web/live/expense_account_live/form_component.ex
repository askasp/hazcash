defmodule HazCashWeb.ExpenseAccountLive.FormComponent do
  use HazCashWeb, :live_component

  alias HazCash.Core

  @impl true
  def update(%{expense_account: expense_account} = assigns, socket) do
    changeset = Core.change_expense_account(expense_account)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"expense_account" => expense_account_params}, socket) do
    changeset =
      socket.assigns.expense_account
      |> Core.change_expense_account(expense_account_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"expense_account" => expense_account_params}, socket) do
    save_expense_account(socket, socket.assigns.action, expense_account_params)
  end

  defp save_expense_account(socket, :edit, expense_account_params) do
    case Core.update_expense_account(socket.assigns.expense_account, expense_account_params) do
      {:ok, _expense_account} ->
        {:noreply,
         socket
         |> put_flash(:info, "Expense account updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_expense_account(socket, :new, expense_account_params) do
    case Core.create_expense_account(expense_account_params) do
      {:ok, _expense_account} ->
        {:noreply,
         socket
         |> put_flash(:info, "Expense account created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
