defmodule HazCash.Repo.Migrations.CreateExpense do
  use Ecto.Migration

  def change do
    create table(:expenses, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :description, :string
      add :amount, :integer
      add :month, :string
      add :year, :string
      add :account_id, references(:accounts, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:expenses, [:account_id])
    
    # create unique_index(:expenses, [:account_id, :month, :year], name: "should_be_same_expense_index")
    
  end
end
