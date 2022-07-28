defmodule HazCash.Repo.Migrations.ExpenseLabels do
  use Ecto.Migration

  def change do
    create table(:expense_labels) do
      add :expense_id, references(:expenses)
      add :label_id, references(:labels)
    timestamps()
    end  

  end
end
