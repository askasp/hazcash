defmodule HazCash.Billing.ProductsTest do
  use HazCash.DataCase

  import HazCash.BillingFixtures

  alias HazCash.Billing.Products
  alias HazCash.Billing.Product

  describe "products" do
    @invalid_attrs %{active: nil, description: nil, local_description: nil, local_name: nil, name: nil, stripe_id: nil}

    test "paginate_products/1 returns paginated list of products" do
      for _ <- 1..20 do
        product_fixture()
      end

      {:ok, %{entries: products} = page} = Products.paginate_products(%{})

      assert length(products) == 15
      assert page.page_number == 1
      assert page.page_size == 15
      assert page.total_pages == 2
      assert page.total_entries == 20
      assert page.distance == 5
      assert page.sort_field == "inserted_at"
      assert page.sort_direction == "desc"
    end

    test "list_products/0 returns all products" do
      product = product_fixture()
      assert Products.list_products() == [product]
    end

    test "get_product!/1 returns the product with given id" do
      product = product_fixture()
      assert Products.get_product!(product.id) == product
    end

    test "get_product_by_stripe_id!/1 returns the product with given stripe_id" do
      product = product_fixture()
      assert Products.get_product_by_stripe_id!(product.stripe_id) == product
    end

    test "create_product/1 with valid data creates a product" do
      valid_attrs = %{active: true, description: "some description", local_description: "some local_description", local_name: "some local_name", name: "some name", stripe_id: "some stripe_id"}

      assert {:ok, %Product{} = product} = Products.create_product(valid_attrs)
      assert product.active == true
      assert product.description == "some description"
      assert product.local_description == "some local_description"
      assert product.local_name == "some local_name"
      assert product.name == "some name"
      assert product.stripe_id == "some stripe_id"
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Products.create_product(@invalid_attrs)
    end

    test "update_product/2 with valid data updates the product" do
      product = product_fixture()
      update_attrs = %{active: false, description: "some updated description", local_description: "some updated local_description", local_name: "some updated local_name", name: "some updated name", stripe_id: "some updated stripe_id"}

      assert {:ok, %Product{} = product} = Products.update_product(product, update_attrs)
      assert product.active == false
      assert product.description == "some updated description"
      assert product.local_description == "some updated local_description"
      assert product.local_name == "some updated local_name"
      assert product.name == "some updated name"
      assert product.stripe_id == "some updated stripe_id"
    end

    test "update_product/2 with invalid data returns error changeset" do
      product = product_fixture()
      assert {:error, %Ecto.Changeset{}} = Products.update_product(product, @invalid_attrs)
      assert product == Products.get_product!(product.id)
    end

    test "delete_product/1 deletes the product" do
      product = product_fixture()
      assert {:ok, %Product{}} = Products.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> Products.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset" do
      product = product_fixture()
      assert %Ecto.Changeset{} = Products.change_product(product)
    end
  end
end
