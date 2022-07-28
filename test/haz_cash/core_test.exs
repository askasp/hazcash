defmodule HazCash.CoreTest do
  use HazCash.DataCase

  alias HazCash.Core

  describe "transfers" do
    alias HazCash.Core.Transfer

    import HazCash.CoreFixtures

    @invalid_attrs %{actual_month: nil, actual_year: nil, description: nil, expected_month: nil, expected_year: nil, from: nil, labels: nil, status: nil, to: nil, type: nil}

    test "list_transfers/0 returns all transfers" do
      transfer = transfer_fixture()
      assert Core.list_transfers() == [transfer]
    end

    test "get_transfer!/1 returns the transfer with given id" do
      transfer = transfer_fixture()
      assert Core.get_transfer!(transfer.id) == transfer
    end

    test "create_transfer/1 with valid data creates a transfer" do
      valid_attrs = %{actual_month: "some actual_month", actual_year: "some actual_year", description: "some description", expected_month: "some expected_month", expected_year: "some expected_year", from: %{}, labels: [], status: :confirmed, to: %{}, type: :expense}

      assert {:ok, %Transfer{} = transfer} = Core.create_transfer(valid_attrs)
      assert transfer.actual_month == "some actual_month"
      assert transfer.actual_year == "some actual_year"
      assert transfer.description == "some description"
      assert transfer.expected_month == "some expected_month"
      assert transfer.expected_year == "some expected_year"
      assert transfer.from == %{}
      assert transfer.labels == []
      assert transfer.status == :confirmed
      assert transfer.to == %{}
      assert transfer.type == :expense
    end

    test "create_transfer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Core.create_transfer(@invalid_attrs)
    end

    test "update_transfer/2 with valid data updates the transfer" do
      transfer = transfer_fixture()
      update_attrs = %{actual_month: "some updated actual_month", actual_year: "some updated actual_year", description: "some updated description", expected_month: "some updated expected_month", expected_year: "some updated expected_year", from: %{}, labels: [], status: :secure, to: %{}, type: :income}

      assert {:ok, %Transfer{} = transfer} = Core.update_transfer(transfer, update_attrs)
      assert transfer.actual_month == "some updated actual_month"
      assert transfer.actual_year == "some updated actual_year"
      assert transfer.description == "some updated description"
      assert transfer.expected_month == "some updated expected_month"
      assert transfer.expected_year == "some updated expected_year"
      assert transfer.from == %{}
      assert transfer.labels == []
      assert transfer.status == :secure
      assert transfer.to == %{}
      assert transfer.type == :income
    end

    test "update_transfer/2 with invalid data returns error changeset" do
      transfer = transfer_fixture()
      assert {:error, %Ecto.Changeset{}} = Core.update_transfer(transfer, @invalid_attrs)
      assert transfer == Core.get_transfer!(transfer.id)
    end

    test "delete_transfer/1 deletes the transfer" do
      transfer = transfer_fixture()
      assert {:ok, %Transfer{}} = Core.delete_transfer(transfer)
      assert_raise Ecto.NoResultsError, fn -> Core.get_transfer!(transfer.id) end
    end

    test "change_transfer/1 returns a transfer changeset" do
      transfer = transfer_fixture()
      assert %Ecto.Changeset{} = Core.change_transfer(transfer)
    end
  end

  describe "expense_accounts" do
    alias HazCash.Core.ExpenseAccount

    import HazCash.CoreFixtures

    @invalid_attrs %{name: nil, priority: nil}

    test "list_expense_accounts/0 returns all expense_accounts" do
      expense_account = expense_account_fixture()
      assert Core.list_expense_accounts() == [expense_account]
    end

    test "get_expense_account!/1 returns the expense_account with given id" do
      expense_account = expense_account_fixture()
      assert Core.get_expense_account!(expense_account.id) == expense_account
    end

    test "create_expense_account/1 with valid data creates a expense_account" do
      valid_attrs = %{name: "some name", priority: 42}

      assert {:ok, %ExpenseAccount{} = expense_account} = Core.create_expense_account(valid_attrs)
      assert expense_account.name == "some name"
      assert expense_account.priority == 42
    end

    test "create_expense_account/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Core.create_expense_account(@invalid_attrs)
    end

    test "update_expense_account/2 with valid data updates the expense_account" do
      expense_account = expense_account_fixture()
      update_attrs = %{name: "some updated name", priority: 43}

      assert {:ok, %ExpenseAccount{} = expense_account} = Core.update_expense_account(expense_account, update_attrs)
      assert expense_account.name == "some updated name"
      assert expense_account.priority == 43
    end

    test "update_expense_account/2 with invalid data returns error changeset" do
      expense_account = expense_account_fixture()
      assert {:error, %Ecto.Changeset{}} = Core.update_expense_account(expense_account, @invalid_attrs)
      assert expense_account == Core.get_expense_account!(expense_account.id)
    end

    test "delete_expense_account/1 deletes the expense_account" do
      expense_account = expense_account_fixture()
      assert {:ok, %ExpenseAccount{}} = Core.delete_expense_account(expense_account)
      assert_raise Ecto.NoResultsError, fn -> Core.get_expense_account!(expense_account.id) end
    end

    test "change_expense_account/1 returns a expense_account changeset" do
      expense_account = expense_account_fixture()
      assert %Ecto.Changeset{} = Core.change_expense_account(expense_account)
    end
  end

  describe "expense" do
    alias HazCash.Core.Expense

    import HazCash.CoreFixtures

    @invalid_attrs %{amount: nil, description: nil, month: nil, year: nil}

    test "list_expense/0 returns all expense" do
      expense = expense_fixture()
      assert Core.list_expense() == [expense]
    end

    test "get_expense!/1 returns the expense with given id" do
      expense = expense_fixture()
      assert Core.get_expense!(expense.id) == expense
    end

    test "create_expense/1 with valid data creates a expense" do
      valid_attrs = %{amount: 42, description: "some description", month: "some month", year: "some year"}

      assert {:ok, %Expense{} = expense} = Core.create_expense(valid_attrs)
      assert expense.amount == 42
      assert expense.description == "some description"
      assert expense.month == "some month"
      assert expense.year == "some year"
    end

    test "create_expense/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Core.create_expense(@invalid_attrs)
    end

    test "update_expense/2 with valid data updates the expense" do
      expense = expense_fixture()
      update_attrs = %{amount: 43, description: "some updated description", month: "some updated month", year: "some updated year"}

      assert {:ok, %Expense{} = expense} = Core.update_expense(expense, update_attrs)
      assert expense.amount == 43
      assert expense.description == "some updated description"
      assert expense.month == "some updated month"
      assert expense.year == "some updated year"
    end

    test "update_expense/2 with invalid data returns error changeset" do
      expense = expense_fixture()
      assert {:error, %Ecto.Changeset{}} = Core.update_expense(expense, @invalid_attrs)
      assert expense == Core.get_expense!(expense.id)
    end

    test "delete_expense/1 deletes the expense" do
      expense = expense_fixture()
      assert {:ok, %Expense{}} = Core.delete_expense(expense)
      assert_raise Ecto.NoResultsError, fn -> Core.get_expense!(expense.id) end
    end

    test "change_expense/1 returns a expense changeset" do
      expense = expense_fixture()
      assert %Ecto.Changeset{} = Core.change_expense(expense)
    end
  end

  describe "labels" do
    alias HazCash.Core.Label

    import HazCash.CoreFixtures

    @invalid_attrs %{name: nil}

    test "list_labels/0 returns all labels" do
      label = label_fixture()
      assert Core.list_labels() == [label]
    end

    test "get_label!/1 returns the label with given id" do
      label = label_fixture()
      assert Core.get_label!(label.id) == label
    end

    test "create_label/1 with valid data creates a label" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Label{} = label} = Core.create_label(valid_attrs)
      assert label.name == "some name"
    end

    test "create_label/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Core.create_label(@invalid_attrs)
    end

    test "update_label/2 with valid data updates the label" do
      label = label_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Label{} = label} = Core.update_label(label, update_attrs)
      assert label.name == "some updated name"
    end

    test "update_label/2 with invalid data returns error changeset" do
      label = label_fixture()
      assert {:error, %Ecto.Changeset{}} = Core.update_label(label, @invalid_attrs)
      assert label == Core.get_label!(label.id)
    end

    test "delete_label/1 deletes the label" do
      label = label_fixture()
      assert {:ok, %Label{}} = Core.delete_label(label)
      assert_raise Ecto.NoResultsError, fn -> Core.get_label!(label.id) end
    end

    test "change_label/1 returns a label changeset" do
      label = label_fixture()
      assert %Ecto.Changeset{} = Core.change_label(label)
    end
  end
end
