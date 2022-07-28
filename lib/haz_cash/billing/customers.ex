defmodule HazCash.Billing.Customers do
  @moduledoc """
  The Billing Customers context.
  """

  import Ecto.Query, warn: false
  alias HazCash.Repo
  alias HazCash.Billing.Customer
  alias HazCash.Billing.Subscription

  @doc """
  Returns the paginated list of customers.

  ## Examples

      iex> paginate_customers(%{})
      %{entries: [%Customer{}, ...]}

  """
  def paginate_customers(params \\ %{}) do
    query = (from c in Customer, where: is_nil(c.stripe_id) == false)
    HazCash.Pagination.paginate_records(query, params)
  end

  @doc """
  Returns the list of customers.

  ## Examples

      iex> list_customers()
      [%Customer{}, ...]

  """
  def list_customers do
    (from c in Customer, where: is_nil(c.stripe_id) == false)
    |> Repo.all()
  end

  @doc """
  Gets a single customer.

  Raises `Ecto.NoResultsError` if the Customer does not exist.

  ## Examples

      iex> get_customer!(123)
      %Customer{}

      iex> get_customer!(456)
      ** (Ecto.NoResultsError)

  """
  def get_customer!(id), do: Repo.get!(Customer, id)

  @doc """
  Gets a single customer by Stripe Id.

  Raises `Ecto.NoResultsError` if the Customer does not exist.

  ## Examples

      iex> get_customer_by_stripe_id!(123)
      %Customer{}

      iex> get_customer_by_stripe_id!(456)
      ** (Ecto.NoResultsError)

  """
  def get_customer_by_stripe_id!(stripe_id), do: Repo.get_by!(Customer, stripe_id: stripe_id)

  @doc """
  Gets a customer for a user.

  returns nil if the Customer does not exist.

  ## Examples

      iex> get_billing_customer_for_user(123)
      %Customer{}

      iex> get_billing_customer_for_user(456)
      nil

  """
  def get_billing_customer_for_user(user) do
    Repo.get_by!(Customer, id: user.id)
  end

  @doc """
  Returns subscriptions associations for one pr many customers.

  ## Examples

      iex> with_subscriptions(account)
      %Customer{subscriptions: [...]}

  """
  def with_subscriptions(customer_or_customers) do
    customer_or_customers
    |> Repo.preload(subscriptions: (from s in Subscription, order_by: [desc: :inserted_at]))
  end

  @doc """
  Updates a customer.

  ## Examples

      iex> update_customer(customer, %{field: new_value})
      {:ok, %Customer{}}

      iex> update_customer(customer, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_customer(%Customer{} = customer, attrs) do
    customer
    |> Customer.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a customer.

  ## Examples

      iex> delete_customer(customer)
      {:ok, %Customer{}}

      iex> delete_customer(customer)
      {:error, %Ecto.Changeset{}}

  """
  def delete_customer(%Customer{} = customer) do
    Repo.delete(customer)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking customer changes.

  ## Examples

      iex> change_customer(customer)
      %Ecto.Changeset{data: %Customer{}}

  """
  def change_customer(%Customer{} = customer, attrs \\ %{}) do
    Customer.changeset(customer, attrs)
  end

  @doc """
  Gets a single customer for a account_id.

  Returns nil if the Customer does not exist.

  ## Examples

      iex> get_billing_customer_for_account(%Account{id: 123})
      %Customer{}

      iex> get_billing_customer_for_account(%Account{id: 456})
      nil

  """
  def get_billing_customer_for_account(%{personal: true, created_by_user_id: id}) do
    get_customer!(id)
  end

  def get_billing_customer_for_account(account) do
    membership =
      (
        from m in HazCash.Accounts.Membership,
        where: m.account_id == ^account.id,
        where: m.billing_customer == true
      )
      |> Repo.one(account_id: account.id)

    case membership do
      nil -> nil
      %{user_id: id} -> get_customer!(id)
    end
  end
end
