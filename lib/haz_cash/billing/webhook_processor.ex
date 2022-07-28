defmodule HazCash.Billing.WebhookProcessor do
  @moduledoc """
  This GenServer subscripes on incoming webhooks and run the corresponding code.
  """
  use GenServer

  alias HazCashWeb.StripeWebhookController
  alias HazCash.Billing.SynchronizeProducts
  alias HazCash.Billing.SynchronizePlans
  alias HazCash.Billing.HandleSubscriptions
  alias HazCash.Billing.HandleInvoices
  alias HazCash.Billing.HandlePaymentMethods

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(state) do
    StripeWebhookController.subscribe_on_webhook_recieved()
    {:ok, state}
  end

  def handle_info(%{event: event}, state) do
    notify_subscribers(event)

    case event.type do
      "product." <> _ -> SynchronizeProducts.run()
      "plan." <> _ -> SynchronizePlans.run()
      "customer.subscription.created" -> HandleSubscriptions.create_subscription(event.data.object)
      "customer.subscription." <> _ -> HandleSubscriptions.update_subscription(event.data.object)
      "invoice." <> _ -> HandleInvoices.create_or_update_invoice(event.data.object)
      "payment_method.attached" -> HandlePaymentMethods.add_card_info(event.data.object)
      "payment_method.detached" -> HandlePaymentMethods.remove_card_info(event.data.object)
      _ -> nil
    end

    {:noreply, state}
  end

  def subscribe do
    Phoenix.PubSub.subscribe(HazCash.PubSub, "webhook_processed")
  end

  def notify_subscribers(event) do
    Phoenix.PubSub.broadcast(HazCash.PubSub, "webhook_processed", {:event, event})
  end

  defmodule Stub do
    @moduledoc "This is only used in tests"
    use GenServer
    def start_link(_), do: GenServer.start_link(__MODULE__, nil)
    def init(state), do: {:ok, state}
  end
end
