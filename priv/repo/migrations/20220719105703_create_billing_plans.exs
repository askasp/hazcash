defmodule HazCash.Repo.Migrations.CreateBillingPlans do
  use Ecto.Migration

  def change do
    create table(:billing_plans, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :active, :boolean, default: false, null: false
      add :amount, :integer
      add :currency, :string
      add :interval, :string
      add :interval_count, :integer
      add :name, :string
      add :nickname, :string
      add :stripe_id, :string
      add :trial_period_days, :integer
      add :usage_type, :string
      add :product_id, references(:billing_products, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end
    create index(:billing_plans, [:product_id])
    create unique_index(:billing_plans, [:stripe_id])
  end
end