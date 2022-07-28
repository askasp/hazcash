defmodule HazCash.Repo.Migrations.AddBillingCustomerToMemberships do
  use Ecto.Migration

  def change do
    alter table(:account_memberships) do
      add :billing_customer, :boolean, default: false, null: false
    end

    # Only allow one billing customer per account
    # If you want to change this. Remove this line before migrations or make a migration that reverses this.
    # name of the index: account_memberships_account_id_billing_customer_index
    create unique_index(:account_memberships, [:account_id, :billing_customer], where: "billing_customer = true")
  end
end