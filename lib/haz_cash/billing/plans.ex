defmodule HazCash.Billing.Plans do
  @moduledoc """
  The Billing Plans context.
  """

  import Ecto.Query, warn: false
  alias HazCash.Repo
  alias HazCash.Billing.Plan

  @doc """
  Returns the paginated list of plans for a single product.

  ## Examples

      iex> paginate_plans(product, %{})
      %{entries: [%Plan{}, ...]}

  """
  def paginate_plans(product, params \\ %{}) do
    (from p in Plan, where: p.product_id == ^product.id)
    |> HazCash.Pagination.paginate_records(params)
  end

  @doc """
  Returns the list of plans.

  ## Examples

      iex> list_plans()
      [%Plan{}, ...]

  """
  def list_plans() do
    Repo.all(Plan)
  end

  @doc """
  Gets a single plan for a specific product.

  Raises `Ecto.NoResultsError` if the Plan does not exist.

  ## Examples

      iex> get_plan!(product, 123)
      %Plan{}

      iex> get_plan!(product, 456)
      ** (Ecto.NoResultsError)

  """
  def get_plan!(product, id), do: Repo.get_by!(Plan, product_id: product.id, id: id)

  @doc """
  Gets a single plan by Stripe Id.

  Raises `Ecto.NoResultsError` if the Plan does not exist.

  ## Examples

      iex> get_plan_by_stripe_id!(123)
      %Plan{}

      iex> get_plan_by_stripe_id!(456)
      ** (Ecto.NoResultsError)

  """
  def get_plan_by_stripe_id!(stripe_id), do: Repo.get_by!(Plan, stripe_id: stripe_id)

  @doc """
  Creates a plan for a specific product.

  ## Examples

      iex> create_plan(product, %{field: value})
      {:ok, %Plan{}}

      iex> create_plan(product, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_plan(product, attrs \\ %{}) do
    %Plan{}
    |> Plan.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:product, product)
    |> Repo.insert()
  end

  @doc """
  Updates a plan.

  ## Examples

      iex> update_plan(plan, %{field: new_value})
      {:ok, %Plan{}}

      iex> update_plan(plan, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_plan(%Plan{} = plan, attrs) do
    plan
    |> Plan.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a plan.

  ## Examples

      iex> delete_plan(plan)
      {:ok, %Plan{}}

      iex> delete_plan(plan)
      {:error, %Ecto.Changeset{}}

  """
  def delete_plan(%Plan{} = plan) do
    Repo.delete(plan)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking plan changes.

  ## Examples

      iex> change_plan(plan)
      %Ecto.Changeset{data: %Plan{}}

  """
  def change_plan(%Plan{} = plan, attrs \\ %{}) do
    Plan.changeset(plan, attrs)
  end
end
