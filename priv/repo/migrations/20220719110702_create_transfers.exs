defmodule HazCash.Repo.Migrations.CreateTransfers do
  use Ecto.Migration

  def change do
    create table(:transfers, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :type, :string
      add :expected_month, :string
      add :actual_month, :string
      add :expected_year, :string
      add :actual_year, :string
      add :status, :string
      add :labels, {:array, :string}
      add :from, :map
      add :to, :map
      add :description, :string

      timestamps()
    end
  end
end
