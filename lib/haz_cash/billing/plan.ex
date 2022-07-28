defmodule HazCash.Billing.Plan do
  @moduledoc """
  The plan schema.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "billing_plans" do
    field :active, :boolean
    field :amount, :integer
    field :currency, :string
    field :interval, :string
    field :interval_count, :integer
    field :name, :string
    field :nickname, :string
    field :stripe_id, :string
    field :trial_period_days, :integer
    field :usage_type, :string

    belongs_to :product, HazCash.Billing.Product

    timestamps()
  end

  @doc false
  def changeset(plan, attrs) do
    plan
    |> cast(attrs, [:active, :amount, :currency, :interval, :interval_count, :name, :nickname, :stripe_id, :trial_period_days, :usage_type])
    |> validate_required([:stripe_id])
    |> unique_constraint(:stripe_id, name: :billing_plans_stripe_id_index)
  end
end
