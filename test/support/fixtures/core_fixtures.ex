defmodule HazCash.CoreFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `HazCash.Core` context.
  """

  @doc """
  Generate a transfer.
  """
  def transfer_fixture(attrs \\ %{}) do
    {:ok, transfer} =
      attrs
      |> Enum.into(%{
        actual_month: "some actual_month",
        actual_year: "some actual_year",
        description: "some description",
        expected_month: "some expected_month",
        expected_year: "some expected_year",
        from: %{},
        labels: [],
        status: :confirmed,
        to: %{},
        type: :expense
      })
      |> HazCash.Core.create_transfer()

    transfer
  end

  @doc """
  Generate a expense_account.
  """
  def expense_account_fixture(attrs \\ %{}) do
    {:ok, expense_account} =
      attrs
      |> Enum.into(%{
        name: "some name",
        priority: 42
      })
      |> HazCash.Core.create_expense_account()

    expense_account
  end

  @doc """
  Generate a expense.
  """
  def expense_fixture(attrs \\ %{}) do
    {:ok, expense} =
      attrs
      |> Enum.into(%{
        amount: 42,
        description: "some description",
        month: "some month",
        year: "some year"
      })
      |> HazCash.Core.create_expense()

    expense
  end

  @doc """
  Generate a label.
  """
  def label_fixture(attrs \\ %{}) do
    {:ok, label} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> HazCash.Core.create_label()

    label
  end
end
