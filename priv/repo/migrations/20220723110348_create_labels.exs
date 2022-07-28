defmodule HazCash.Repo.Migrations.CreateLabels do
  use Ecto.Migration

  def change do
    create table(:labels, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :key, :string
      add :value, :string
      add :account_id, references(:accounts, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:labels, [:account_id])
  end
end
