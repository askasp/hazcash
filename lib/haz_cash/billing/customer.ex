defmodule HazCash.Billing.Customer do
  @moduledoc """
  The customer schema.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :email, :string
    field :card_brand, :string
    field :card_exp_month, :integer
    field :card_exp_year, :integer
    field :card_last4, :string
    field :stripe_id, :string

    has_many :subscriptions, HazCash.Billing.Subscription

    timestamps()
  end

  @doc false
  def changeset(customer, attrs) do
    customer
    |> cast(attrs, [:card_brand, :card_exp_month, :card_exp_year, :card_last4, :stripe_id])
    |> validate_required([:stripe_id])
    |> unique_constraint(:stripe_id, name: :users_stripe_id_index)
  end
end
