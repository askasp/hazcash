defmodule HazCash.Core.Transfer do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "transfers" do
    field :actual_month, :string
    field :actual_year, :string
    field :description, :string
    field :expected_month, :string
    field :expected_year, :string
    field :from, :map
    field :labels, {:array, :string}
    field :status, Ecto.Enum, values: [:confirmed, :secure, :insecureamount, :integer]
    field :to, :map
    field :type, Ecto.Enum, values: [:expense, :income]

    timestamps()
  end

  @doc false
  def changeset(transfer, attrs) do
    transfer
    |> cast(attrs, [:type, :expected_month, :actual_month, :expected_year, :actual_year, :status, :labels, :from, :to, :description])
    |> validate_required([:type, :expected_month, :actual_month, :expected_year, :actual_year, :status, :labels, :from, :to, :description])
  end
end
