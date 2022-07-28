defmodule HazCash.Billing.Subscription do
  @moduledoc """
  The subscription schema.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "billing_subscriptions" do
    field :cancel_at, :naive_datetime
    field :canceled_at, :naive_datetime
    field :current_period_end_at, :naive_datetime
    field :current_period_start, :naive_datetime
    field :status, :string
    field :stripe_id, :string

    belongs_to :customer, HazCash.Billing.Customer
    belongs_to :plan, HazCash.Billing.Plan

    timestamps()
  end

  @doc false
  def changeset(subscription, attrs) do
    subscription
    |> cast(attrs, [:cancel_at, :canceled_at, :current_period_end_at, :current_period_start, :status, :stripe_id])
    |> validate_required([:stripe_id])
    |> unique_constraint(:stripe_id, name: :billing_subscriptions_stripe_id_index)
  end
end
