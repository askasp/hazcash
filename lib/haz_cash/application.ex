defmodule HazCash.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      HazCash.Repo,
      # Start the Telemetry supervisor
      HazCashWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: HazCash.PubSub},
      # Start the Endpoint (http/https)
      HazCashWeb.Endpoint,
      # Start a worker by calling: HazCash.Worker.start_link(arg)
      # {HazCash.Worker, arg}
      {Oban, oban_config()},
      webhook_processor_service(),
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HazCash.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    HazCashWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp oban_config do
    Application.fetch_env!(:haz_cash, Oban)
  end

  # Dont start the genserver in test mode
  defp webhook_processor_service do
    if Application.get_env(:haz_cash, :env) == :test,
      do: HazCash.Billing.WebhookProcessor.Stub,
      else: HazCash.Billing.WebhookProcessor
  end
end
