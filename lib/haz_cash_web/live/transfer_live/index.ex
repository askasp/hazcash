defmodule HazCashWeb.TransferLive.Index do
  use HazCashWeb, :live_view

  alias HazCash.Core
  alias HazCash.Core.Transfer

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :transfers, list_transfers())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Transfer")
    |> assign(:transfer, Core.get_transfer!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Transfer")
    |> assign(:transfer, %Transfer{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Transfers")
    |> assign(:transfer, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    transfer = Core.get_transfer!(id)
    {:ok, _} = Core.delete_transfer(transfer)

    {:noreply, assign(socket, :transfers, list_transfers())}
  end

  defp list_transfers do
    Core.list_transfers()
  end
end
