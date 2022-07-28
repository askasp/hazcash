defmodule HazCash.Repo.Migrations.CreateBillingCustomers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :stripe_id, :string
      add :payment_method_stripe_id, :string
      add :card_brand, :string
      add :card_exp_month, :integer
      add :card_exp_year, :integer
      add :card_last4, :string
    end

    create unique_index(:users, [:stripe_id])
  end
end