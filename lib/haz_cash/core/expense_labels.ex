defmodule HazCash.Core.ExpenseLabel do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "expense_labels" do
    belongs_to :expense , HazCash.Core.Expense
    belongs_to :label, HazCash.Core.Label
    
    timestamps()
  end

  @doc false
  def changeset(label, attrs) do
    label
    |> cast(attrs, [:expense_id, :label_id])
    |> validate_required([:expense_id, :label_id])
  end
end
