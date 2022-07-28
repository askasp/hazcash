defmodule HazCash.Billing.Invoice do
  @moduledoc """
  The invoice schema.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "billing_invoices" do
    field :hosted_invoice_url, :string
    field :invoice_pdf, :string
    field :status, :string
    field :stripe_id, :string
    field :subtotal, :integer

    belongs_to :customer, HazCash.Billing.Customer

    timestamps()
  end

  @doc false
  def changeset(invoice, attrs) do
    invoice
    |> cast(attrs, [:hosted_invoice_url, :invoice_pdf, :status, :stripe_id, :subtotal])
    |> validate_required([:stripe_id])
    |> unique_constraint(:stripe_id, name: :billing_invoices_stripe_id_index)
  end
end
