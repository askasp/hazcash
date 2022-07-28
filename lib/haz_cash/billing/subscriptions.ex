defmodule HazCash.Billing.Subscriptions do
  @moduledoc """
  The Billing context.
  """

  import Ecto.Query, warn: false
  alias HazCash.Repo
  alias HazCash.Billing.Subscription

  @doc """
  Returns the paginated list of subscriptions.

  ## Examples

      iex> paginate_subscriptions(%{})
      %{entries: [%Subscription{}, ...]}

  """
  def paginate_subscriptions(params \\ %{}) do
    HazCash.Pagination.paginate_records(Subscription, params)
  end

  @doc """
  Returns the list of subscriptions for a specific customer.

  ## Examples

      iex> list_subscriptions(customer)
      [%Subscription{}, ...]

  """
  def list_subscriptions() do
    Repo.all(Subscription)
  end

  @doc """
  Gets a single subscription.

  Raises `Ecto.NoResultsError` if the Subscription does not exist.

  ## Examples

      iex> get_subscription!(123)
      %Subscription{}

      iex> get_subscription!(456)
      ** (Ecto.NoResultsError)

  """
  def get_subscription!(id), do: Repo.get_by!(Subscription, id: id)

  @doc """
  Gets a single subscription by Stripe Id.

  Raises `Ecto.NoResultsError` if the Subscription does not exist.

  ## Examples

      iex> get_subscription_by_stripe_id!(123)
      %Subscription{}

      iex> get_subscription_by_stripe_id!(456)
      ** (Ecto.NoResultsError)

  """
  def get_subscription_by_stripe_id!(stripe_id), do: Repo.get_by!(Subscription, stripe_id: stripe_id)

  @doc """
  Creates a subscription for a specific customer and plan.

  ## Examples

      iex> create_subscription(customer, plan, %{field: value})
      {:ok, %Subscription{}}

      iex> create_subscription(customer, plan, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_subscription(customer, plan, attrs \\ %{}) do
    %Subscription{}
    |> Subscription.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:customer, customer)
    |> Ecto.Changeset.put_assoc(:plan, plan)
    |> Repo.insert()
  end

  @doc """
  Updates a subscription.

  ## Examples

      iex> update_subscription(subscription, %{field: new_value})
      {:ok, %Subscription{}}

      iex> update_subscription(subscription, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_subscription(%Subscription{} = subscription, attrs) do
    subscription
    |> Subscription.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a subscription.

  ## Examples

      iex> delete_subscription(subscription)
      {:ok, %Subscription{}}

      iex> delete_subscription(subscription)
      {:error, %Ecto.Changeset{}}

  """
  def delete_subscription(%Subscription{} = subscription) do
    Repo.delete(subscription)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking subscription changes.

  ## Examples

      iex> change_subscription(subscription)
      %Ecto.Changeset{data: %Subscription{}}

  """
  def change_subscription(%Subscription{} = subscription, attrs \\ %{}) do
    Subscription.changeset(subscription, attrs)
  end

  @doc """
  Gets a single active subscription for a billing customer.

  Returns `nil` if an active Subscription does not exist.

  ## Examples

      iex> get_active_subscription_for_customer(123)
      %Subscription{}

      iex> get_active_subscription_for_customer(456)
      nil

  """
  def get_active_subscription_for_customer(customer) do
    from(s in Subscription,
      join: c in assoc(s, :customer),
      where: c.id == ^customer.id,
      where: is_nil(s.cancel_at) or s.cancel_at > ^NaiveDateTime.utc_now(),
      where: s.current_period_end_at > ^NaiveDateTime.utc_now(),
      where: s.status == "active",
      limit: 1
    )
    |> Repo.one()
  end
end
