defmodule HazCashWeb.AccountLive.FormComponent do
  @moduledoc """
  This component is used for creating an account and setting the first
  membership.
  """
  use HazCashWeb, :live_component

  alias HazCash.Accounts
  alias HazCash.Accounts.Account
  alias HazCash.Core

  @impl true
  def update(assigns, socket) do
    changeset = Accounts.change_account(%Account{})

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("save", %{"account" => account_params}, socket) do
    user = socket.assigns.current_user
    case Accounts.create_account(user, account_params) do
      {:ok, account} ->
        {:ok, _} = Core.auto_populate_standard_labels(account.id)


       Accounts.create_membership(account, user, %{role: :owner})

        {:noreply,
         socket
         |> put_flash(:info, "Account created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
