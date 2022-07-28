defmodule HazCash.Accounts.Membership do
  @moduledoc """
  The Member Schema. A member is the relationship between users and accounts
  and tells which accounts a user have access to
  """
  use HazCash.Schema
  import Ecto.Changeset

  schema "account_memberships" do
    field :role, Ecto.Enum, values: [:owner, :member], default: :member
    field :billing_customer, :boolean, default: false

    belongs_to :member, HazCash.Accounts.Member, foreign_key: :user_id
    belongs_to :account, HazCash.Accounts.Account

    timestamps()
  end

  @doc false
  def changeset(member, attrs) do
    member
    |> cast(attrs, [:role, :billing_customer])
    |> validate_required([:role])
    |> unique_constraint(:member, name: :account_memberships_account_id_user_id_index)    |> unique_constraint(:billing_customer, name: :account_memberships_account_id_billing_customer_index)

  end
end
