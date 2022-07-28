defmodule HazCash.Billing.SynchronizeProducts do
  @moduledoc """
  This module is responsible for getting data from Stripe
  and storing it in the database. It can be run manually or on a schedule.
  """
  import HazCash.Billing.StripeService

  alias HazCash.Billing.Products

  defp get_all_products_from_stripe do
    {:ok, %{data: products}} = stripe_service(:list_products)
    products
  end

  def run do
    products_by_stripe_id =
      Products.list_products()
      |> Enum.group_by(& &1.stripe_id)

    existing_stripe_ids =
      get_all_products_from_stripe()
      |> Enum.map(fn stripe_product ->
        case Map.get(products_by_stripe_id, stripe_product.id) do
          nil ->
            Products.create_product(%{
              stripe_id: stripe_product.id,
              name: stripe_product.name,
              active: stripe_product.active
            })

          [billing_product] ->
            Products.update_product(billing_product, %{
              name: stripe_product.name,
              active: stripe_product.active
            })
        end
      end)

    products_by_stripe_id
    |> Enum.reject(fn {stripe_id, _billing_product} ->
      Enum.member?(existing_stripe_ids, stripe_id)
    end)
    |> Enum.each(fn {_stripe_id, [billing_product]} ->
      Products.delete_product(billing_product)
    end)
  end
end
