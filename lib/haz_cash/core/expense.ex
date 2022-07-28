defmodule HazCash.Core.Expense do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "expenses" do
    field :amount, :integer
    field :description, :string
    field :month, :string
    field :year, :string
    belongs_to :account, HazCash.Accounts.Account
    many_to_many :labels, HazCash.Core.Label, join_through: "expense_labels", on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(expense, attrs) do
    expense
    |> cast(attrs, [:description, :amount, :month, :year, :account_id])
    |> cast_assoc(:labels, required: false)
    |> validate_required([ :amount, :month, :year, :account_id])
    # |> unique_constraint([:month, :year, :account_id, :expense_account_id], name: :should_be_same_expense_index)
    
  end
end
