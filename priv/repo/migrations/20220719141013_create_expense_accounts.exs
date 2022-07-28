defmodule HazCash.Repo.Migrations.CreateExpenseAccounts do
  use Ecto.Migration

  def change do
    create table(:expense_accounts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :account_id, references(:accounts, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:expense_accounts, [:account_id])
  end
end
