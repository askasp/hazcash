defmodule HazCash.Billing.Invoices do
  @moduledoc """
  The Billing context.
  """

  import Ecto.Query, warn: false
  alias HazCash.Repo
  alias HazCash.Billing.Invoice

  @doc """
  Returns the paginated list of invoices.

  ## Examples

      iex> paginate_invoices(%{})
      %{entries: [%Invoice{}, ...]}

  """
  def paginate_invoices(params \\ %{}) do
    HazCash.Pagination.paginate_records(Invoice, params)
  end

  @doc """
  Returns the list of invoices.

  ## Examples

      iex> list_invoices()
      [%Invoice{}, ...]

  """
  def list_invoices() do
    Repo.all(Invoice)
  end

  @doc """
  Returns the list of invoices for a billing customer.

  ## Examples

      iex> list_invoices_for_billing_customer()
      [%Invoice{}, ...]

  """
  def list_invoices_for_billing_customer(billing_customer) do
    from(i in Invoice,
      where: i.customer_id == ^billing_customer.id,
      order_by: [desc: :inserted_at]
    )
    |> Repo.all()
  end

  @doc """
  Gets a single invoice.

  Raises `Ecto.NoResultsError` if the Invoice does not exist.

  ## Examples

      iex> get_invoice!(123)
      %Invoice{}

      iex> get_invoice!(456)
      ** (Ecto.NoResultsError)

  """
  def get_invoice!(id), do: Repo.get!(Invoice, id)

  @doc """
  Gets a single Invoice by Stripe Id.

  Raises `Ecto.NoResultsError` if the Invoice does not exist.

  ## Examples

      iex> get_invoice_by_stripe_id!(123)
      %Subscription{}

      iex> get_invoice_by_stripe_id!(456)
      ** (Ecto.NoResultsError)

  """
  def get_invoice_by_stripe_id!(stripe_id), do: Repo.get_by!(Invoice, stripe_id: stripe_id)

  @doc """
  Creates a invoice.

  ## Examples

      iex> create_invoice(customer, %{field: value})
      {:ok, %Invoice{}}

      iex> create_invoice(customer, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_invoice(customer, attrs \\ %{}) do
    %Invoice{}
    |> Invoice.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:customer, customer)
    |> Repo.insert()
  end

  @doc """
  Updates a invoice.

  ## Examples

      iex> update_invoice(invoice, %{field: new_value})
      {:ok, %Invoice{}}

      iex> update_invoice(invoice, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_invoice(%Invoice{} = invoice, attrs) do
    invoice
    |> Invoice.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a invoice.

  ## Examples

      iex> delete_invoice(invoice)
      {:ok, %Invoice{}}

      iex> delete_invoice(invoice)
      {:error, %Ecto.Changeset{}}

  """
  def delete_invoice(%Invoice{} = invoice) do
    Repo.delete(invoice)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking invoice changes.

  ## Examples

      iex> change_invoice(invoice)
      %Ecto.Changeset{data: %Invoice{}}

  """
  def change_invoice(%Invoice{} = invoice, attrs \\ %{}) do
    Invoice.changeset(invoice, attrs)
  end
end
