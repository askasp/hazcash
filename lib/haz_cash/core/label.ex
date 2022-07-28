defmodule HazCash.Core.Label do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "labels" do
    field :key, :string
    field :value, :string
    belongs_to :account, HazCash.Accounts.Account
    # many_to_many :expenses, HazCash.Core.Expense, join_through: "expense_labels"
    
    timestamps()
  end

  @doc false
  def changeset(label, attrs) do
    label
    |> cast(attrs, [:key, :value])
    |> validate_required([:key, :value])
  end
end
