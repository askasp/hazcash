defmodule HazCash.Core.ExpenseAccount do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "expense_accounts" do
    field :name, :string
    field :default_labels, {:array, :string}
    belongs_to :account, HazCash.Accounts.Account 
    has_many :expenses, HazCash.Core.Expense

    timestamps()
  end

  @doc false
  def changeset(expense_account, attrs) do
    expense_account
    |> cast(attrs, [:name, :default_labels, :account_id])
    |> validate_required([:name, :account_id])
  end
end
