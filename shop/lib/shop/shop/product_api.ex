defmodule Shop.ProductApi do
  use Absinthe.Schema.Notation
  alias Shop.Repo
  alias Shop.Product

  @doc """
  Graphql product object
  """
  object :product do
    field(:id, :integer)
    field(:title, :string)
    field(:description, :string)
    field(:image, :string)
    field(:price, :float)
  end

  object :product_queries do
    field :all_products, list_of(:product) do
      resolve(fn _, _, _ ->
        results = Repo.all(Product)
        {:ok, results}
      end)
    end
  end

  object :product_mutations do
    field :create_product, :product do
      arg(:title, non_null(:string))
      arg(:description, :string)
      arg(:price, :float)

      resolve(fn _parent, args, _ ->
        %Product{}
        |> Product.changeset(args)
        |> Repo.insert()
      end)
    end

    field :update_product, :product do
      arg(:id, non_null(:integer))
      arg(:title, :string)
      arg(:description, :string)
      arg(:price, :float)

      resolve(fn _parent, args, _ ->
        Repo.get!(Product, args.id)
        |> Product.changeset(args)
        |> Repo.update()
      end)
    end

    field :delete_product, :id do
      arg(:id, non_null(:integer))

      resolve(fn _parent, args, _ ->
        Repo.get!(Product, args.id)
        |> Repo.delete()

        {:ok, args.id}
      end)
    end
  end
end
