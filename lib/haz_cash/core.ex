defmodule HazCash.Core do
  @moduledoc """
  The Core context.
  """

  import Ecto.Query, warn: false
  alias HazCash.Repo

  alias HazCash.Core.Transfer
  alias HazCash.Core.Label

  @doc """
  Returns the list of transfers.

  ## Examples

      iex> list_transfers()
      [%Transfer{}, ...]

  """
  def list_transfers do
    Repo.all(Transfer)
  end

  @doc """
  Gets a single transfer.

  Raises `Ecto.NoResultsError` if the Transfer does not exist.

  ## Examples

      iex> get_transfer!(123)
      %Transfer{}

      iex> get_transfer!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transfer!(id), do: Repo.get!(Transfer, id)

  @doc """
  Creates a transfer.

  ## Examples

      iex> create_transfer(%{field: value})
      {:ok, %Transfer{}}

      iex> create_transfer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transfer(attrs \\ %{}) do
    %Transfer{}
    |> Transfer.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a transfer.

  ## Examples

      iex> update_transfer(transfer, %{field: new_value})
      {:ok, %Transfer{}}

      iex> update_transfer(transfer, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_transfer(%Transfer{} = transfer, attrs) do
    transfer
    |> Transfer.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a transfer.

  ## Examples

      iex> delete_transfer(transfer)
      {:ok, %Transfer{}}

      iex> delete_transfer(transfer)
      {:error, %Ecto.Changeset{}}

  """
  def delete_transfer(%Transfer{} = transfer) do
    Repo.delete(transfer)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transfer changes.

  ## Examples

      iex> change_transfer(transfer)
      %Ecto.Changeset{data: %Transfer{}}

  """
  def change_transfer(%Transfer{} = transfer, attrs \\ %{}) do
    Transfer.changeset(transfer, attrs)
  end

  alias HazCash.Core.ExpenseAccount

  @doc """
  Returns the list of expense_accounts.

  ## Examples

      iex> list_expense_accounts()
      [%ExpenseAccount{}, ...]

  """
  def list_expense_accounts do
    Repo.all(ExpenseAccount)
  end
  
  def list_expense_accounts(account_id) do
    Repo.all(ExpenseAccount, account_id: account_id)
        

  end
  
  def auto_populate_standard_expense_accounts(account_id) do
    # create_expense_account(%{name: "Cantine", default_labels: ["priority: 4"], account_id: account_id})
    # create_expense_account(%{name: "Salary", default_labels: ["priority: 10"], account_id: account_id})
    # create_expense_account(%{name: "Social", default_labels: ["priority: 2"], account_id: account_id})
    # create_expense_account(%{name: "Computers", default_labels: ["priority: 5"], account_id: account_id})
    # create_expense_account(%{name: "Office Supplies", default_labels: ["priority: 4"], account_id: account_id})
    # create_expense_account(%{name: "Other not important", default_labels: ["priority: 1"], account_id: account_id})
    # create_expense_account(%{name: "Other somewhat important", default_labels: ["priority: 5"], account_id: account_id})
    # create_expense_account(%{name: "Other very important", default_labels: ["priority: 10"], account_id: account_id})
  end
  
  def auto_populate_standard_labels(account) do

    create_label(account, %{key: "Priority", value: "1"})
    create_label(account, %{key: "Priority", value: "2"})
    create_label(account, %{key: "Priority", value: "3"})
    create_label(account, %{key: "Certanity", value: "Confirmed"})
    create_label(account, %{key: "Certanity", value: "Secure"})
    create_label(account, %{key: "Certanity", value: "Insecure"})
    create_label(account, %{key: "Expense Account", value: "Salary"})
    create_label(account, %{key: "Expense Account", value: "Food"})
    create_label(account, %{key: "Expense Account", value: "Social"})
    create_label(account, %{key: "Expense Account", value: "Computer"})
    create_label(account, %{key: "Expense Account", value: "Office Supplies"})
    create_label(account, %{key: "Sub Expense Account", value: "Vacation savings"})
    create_label(account, %{key: "Sub Expense Account", value: "Pension savings"})
    create_label(account, %{key: "Sub Expense Account", value: "Salary payout"})
    create_label(account, %{key: "Sub Expense Account", value: "Employeer tax"})
    
    create_label(account, %{key: "Employee", value: "Martin"})
    create_label(account, %{key: "Employee", value: "Aksel"})
    create_label(account, %{key: "Employee", value: "Jacob"})
    
  end
  
  def create_salary_expense(account, yearly_amount_string, employee_name, start_month, end_month, start_year, end_year) do
  {yearly_amount,_} = Integer.parse(yearly_amount_string)
    employee_label = from(l in HazCash.Core.Label, where: l.account_id == ^account.id, where: l.key == "Employee", where: l.value == ^employee_name) 
    |> Repo.one(skip_account_id: true)
    |> case do
      nil ->  {:ok, label} = create_label(account, %{key: "Employee", value: employee_name})
              label
      label -> label
    end

    salary_label = from(l in HazCash.Core.Label, where: l.account_id == ^account.id, where: l.key == "Expense Account", where: l.value == "Salary") 
    |> Repo.one!(skip_account_id: true)

    salary_payout_label = from(l in HazCash.Core.Label, where: l.account_id == ^account.id, where: l.key == "Sub Expense Account", where: l.value == "Salary payout") 
    |> Repo.one!(skip_account_id: true)

    vacation_saving_label = from(l in HazCash.Core.Label, where: l.account_id == ^account.id, where: l.key == "Sub Expense Account", where: l.value == "Vacation savings") 
    |> Repo.one!(skip_account_id: true)   

    pension_saving_label= from(l in HazCash.Core.Label, where: l.account_id == ^account.id, where: l.key == "Sub Expense Account", where: l.value == "Pension savings") 
    |> Repo.one!(skip_account_id: true)
    
    employeer_tax_label= from(l in HazCash.Core.Label, where: l.account_id == ^account.id, where: l.key == "Sub Expense Account", where: l.value == "Employeer tax") 
    |> Repo.one!(skip_account_id: true)
    
    Enum.each(1..11, fn month ->   
      base_amount = floor(yearly_amount / 12)

      {:ok, expense} = create_expense(%{account_id: account.id, amount: base_amount, month: to_string(month), year: "2022"})
      {:ok, _} = create_expense_label(expense.id, salary_label.id)
      {:ok, _} = create_expense_label(expense.id, salary_payout_label.id)
      {:ok, _} = create_expense_label(expense.id, employee_label.id)
      
      employeer_tax_amount= floor(yearly_amount/12*0.14)
      {:ok, expense} = create_expense(%{account_id: account.id, amount: employeer_tax_amount, month: to_string(month), year: "2022"})
      {:ok, _} = create_expense_label(expense.id, salary_label.id)
      {:ok, _} = create_expense_label(expense.id, employeer_tax_label.id)
      {:ok, _} = create_expense_label(expense.id, employee_label.id)
      
      pension_saving_amount= floor(yearly_amount/12*0.04)
      {:ok, expense} = create_expense(%{account_id: account.id, amount: pension_saving_amount, month: to_string(month), year: "2022"})
      {:ok, _} = create_expense_label(expense.id, salary_label.id)
      {:ok, _} = create_expense_label(expense.id, pension_saving_label.id)
      {:ok, _} = create_expense_label(expense.id, employee_label.id)

      vacation_saving_amount= floor(yearly_amount/12*0.12)
      
      {:ok, expense} = create_expense(%{account_id: account.id, amount: vacation_saving_amount, month: to_string(month), year: "2022"})
      {:ok, _} = create_expense_label(expense.id, salary_label.id)
      {:ok, _} = create_expense_label(expense.id, vacation_saving_label.id)
      {:ok, _} = create_expense_label(expense.id, employee_label.id)
      end)
  end
  
  def auto_populate_test_data(account_id) do
   labels= list_labels(account_id)

   nr_of_entries = 100
   1..nr_of_entries
  |> Enum.map(
  fn _ -> 
    labels= labels 
    |> Enum.take_random(Enum.random(1..9))
    |> Enum.uniq_by(fn %{key: key, value: value, id: _} -> key end)

    # month = Enum.random(["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"])    
    month = Enum.random(0..11) |> to_string()
    {:ok, expense} = create_expense(%{account_id: account_id, amount: Enum.random(200..10000), month: month, year: "2022"})
    Enum.each(labels, fn label -> 
    {:ok, _} = create_expense_label(expense.id, label.id)
    end)

  end
  )
  end
  
  

  @doc """
  ets a single expense_account.

  Raises `Ecto.NoResultsError` if the Expense account does not exist.

  ## Examples

      iex> get_expense_account!(123)
      %ExpenseAccount{}

      iex> get_expense_account!(456)
      ** (Ecto.NoResultsError)

  """
  def get_expense_account!(id), do: Repo.get!(ExpenseAccount, id)

  @doc """
  Creates a expense_account.

  ## Examples

      iex> create_expense_account(%{field: value})
      {:ok, %ExpenseAccount{}}

      iex> create_expense_account(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_expense_account(attrs \\ %{}) do
    %ExpenseAccount{}
    |> ExpenseAccount.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a expense_account.

  ## Examples

      iex> update_expense_account(expense_account, %{field: new_value})
      {:ok, %ExpenseAccount{}}

      iex> update_expense_account(expense_account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_expense_account(%ExpenseAccount{} = expense_account, attrs) do
    expense_account
    |> ExpenseAccount.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a expense_account.

  ## Examples

      iex> delete_expense_account(expense_account)
      {:ok, %ExpenseAccount{}}

      iex> delete_expense_account(expense_account)
      {:error, %Ecto.Changeset{}}

  """
  def delete_expense_account(%ExpenseAccount{} = expense_account) do
    Repo.delete(expense_account)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking expense_account changes.

  ## Examples

      iex> change_expense_account(expense_account)
      %Ecto.Changeset{data: %ExpenseAccount{}}

  """
  def change_expense_account(%ExpenseAccount{} = expense_account, attrs \\ %{}) do
    ExpenseAccount.changeset(expense_account, attrs)
  end

  alias HazCash.Core.Expense

  @doc """
  Returns the list of expense.

  ## Examples

      iex> list_expense()
      [%Expense{}, ...]

  """
  def list_expenses do
    Repo.all(Expense)
  end

#TODO not efficient query
  def list_expenses(account_id) do
    Repo.all(Expense, account_id: account_id)
  end
  
  
  def group_expenses_by(expenses, label_keys) do
    tmp = Enum.group_by(expenses, fn x -> 
    Enum.map(label_keys, fn label_key -> 
      Enum.find(x.labels, fn label -> label.key == label_key end)
    end)
    |> Enum.filter(fn label -> label != nil end)
    |> Enum.map(fn label -> "#{label.key}: #{label.value}" end)
    end)

    tmp
  end
  


  
  def group_expenses_by(expenses, :all_labels) do
    Enum.group_by(expenses, fn x -> unique_labels_id(x.labels) end)
  end
  
  def get_expenses(account_id, ids) do
    Enum.map(ids, fn id -> Repo.get!(Expense, id, account_id: account_id) end)
  end
  
  def get_expenses(account_id) do
    querry = from e in Expense, 
      join: l in assoc(e, :labels),
      where: e.account_id == ^account_id,
      preload: [labels: l]
      # group_by: [e.id, l.id, l],
      # order_by: [e.month], l.id]

    Repo.all(querry, skip_account_id: true)
             # |> Enum.reduce(%{}, fn expense, acc-> 
                # label_combo_id = Enum.map(expense.labels, fn label -> label.id)
                # |> Enum.sort
                # |> Enum.join(",")

             # Map.get(acc, expense..id)
      # |> case do
        # nil -> Map.put(acc, expense.expense_account.id, [expense])
        # x -> Map.put(acc, expense.expense_account.id, x ++ [expense])
      # end
      # end)
    # tmp = Enum.map(result, 
    #   fn r -> 
    #     label_ids = Enum.map(r.labels, fn l -> l.id end)
    #     {r.id, r.month, label_ids}
    #     end)
    # IO.inspect tmp
    
    
    # tmp = Enum.group_by(result, fn x -> unique_labels_id(x.labels) end)
    # IO.inspect tmp
      
      
    # tmp
    
  end
  
  defp unique_labels_id(labels) do
  Enum.map(labels, fn label -> label.id end)
  |> Enum.sort
  |> Enum.join("-")
  end



  @doc """
  Gets a single expense.

  Raises `Ecto.NoResultsError` if the Expense does not exist.

  ## Examples

      iex> get_expense!(123)
      %Expense{}

      iex> get_expense!(456)
      ** (Ecto.NoResultsError)

  """
  def get_expense!(id), do: Repo.get!(Expense, id, skip_account_id: true) |> Repo.preload(:expense_account, skip_account_id: true)

  @doc """
  Creates a expense.

  ## Examples

      iex> create_expense(%{field: value})
      {:ok, %Expense{}}

      iex> create_expense(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_expense(attrs \\ %{}) do
    %Expense{}
    |> Expense.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a expense.

  ## Examples

      iex> update_expense(expense, %{field: new_value})
      {:ok, %Expense{}}

      iex> update_expense(expense, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_expense(%Expense{} = expense, attrs) do
    expense
    |> Expense.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a expense.

  ## Examples

      iex> delete_expense(expense)
      {:ok, %Expense{}}

      iex> delete_expense(expense)
      {:error, %Ecto.Changeset{}}

  """
  def delete_expense(%Expense{} = expense) do
    Repo.delete(expense)
  end
  
  def delete_all_expenses(account_id) do
  
  expenses_query = from(el in HazCash.Core.Expense, where: el.account_id == ^account_id)
  expenses = HazCash.Repo.all(expenses_query, skip_account_id: true)
  Enum.each(expenses, fn expense -> 
    from(el in HazCash.Core.ExpenseLabel, where: el.expense_id== ^expense.id)
    |> HazCash.Repo.delete_all(skip_account_id: true)
    end)
    
  HazCash.Repo.delete_all(expenses_query, skip_account_id: true)

  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking expense changes.

  ## Examples

      iex> change_expense(expense)
      %Ecto.Changeset{data: %Expense{}}

  """
  def change_expense(%Expense{} = expense, attrs \\ %{}) do
    Expense.changeset(expense, attrs)
  end

  alias HazCash.Core.Label

  @doc """
  Returns the list of labels.

  ## Examples

      iex> list_labels()
      [%Label{}, ...]

  """
  def list_labels do
    Repo.all(Label)
  end

  def list_labels(account_id) do
    Repo.all(Label, account_id: account_id)
  end

  @doc """
  Gets a single label.

  Raises `Ecto.NoResultsError` if the Label does not exist.

  ## Examples

      iex> get_label!(123)
      %Label{}

      iex> get_label!(456)
      ** (Ecto.NoResultsError)

  """
  def get_label!(id), do: Repo.get!(Label, id, skip_account_id: true)

  @doc """
  Creates a label.

  ## Examples

      iex> create_label(%{field: value})
      {:ok, %Label{}}

      iex> create_label(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_label(account, attrs \\ %{}) do
    %Label{}
    |> Label.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:account, account)
    |> Repo.insert()
  end

  @doc """
  Updates a label.

  ## Examples

      iex> update_label(label, %{field: new_value})
      {:ok, %Label{}}

      iex> update_label(label, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_label(%Label{} = label, attrs) do
    label
    |> Label.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a label.

  ## Examples

      iex> delete_label(label)
      {:ok, %Label{}}

      iex> delete_label(label)
      {:error, %Ecto.Changeset{}}

  """
  def delete_label(%Label{} = label) do
    Repo.delete(label)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking label changes.

  ## Examples

      iex> change_label(label)
      %Ecto.Changeset{data: %Label{}}

  """
  def change_label(%Label{} = label, attrs \\ %{}) do
    Label.changeset(label, attrs)
  end
  

  alias HazCash.Core.ExpenseLabel
  
  def create_expense_label(expense_id, label_id) do
    %ExpenseLabel{}
    |> ExpenseLabel.changeset(%{expense_id: expense_id, label_id: label_id})
    |> Repo.insert
  end

end
