defmodule HazCash.Billing.Product do
  @moduledoc """
  The product schema.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "billing_products" do
    field :active, :boolean
    field :description, :string
    field :local_description, :string
    field :local_name, :string
    field :name, :string
    field :stripe_id, :string

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:active, :description, :local_description, :local_name, :name, :stripe_id])
    |> validate_required([:stripe_id])
    |> unique_constraint(:stripe_id, name: :billing_products_stripe_id_index)
  end
end
