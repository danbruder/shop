defmodule Shop.ProductApi do
  use Absinthe.Schema.Notation
  use Absinthe.Ecto, repo: Shop.Repo
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
    field(:categories, list_of(:category), resolve: assoc(:categories))
  end

  input_object :product_input do
    field(:title, :string)
    field(:description, :string)
    field(:image, :string)
    field(:price, :float)
    field(:categories, list_of(:category_input))
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
      arg(:input, non_null(:product_input))

      resolve(fn _parent, args, _ ->
        %Product{}
        |> Product.changeset(args.input)
        |> Ecto.Changeset.put_assoc(:categories, args.input.categories)
        |> Repo.insert()
      end)
    end

    field :update_product, :product do
      arg(:id, non_null(:integer))
      arg(:input, non_null(:product_input))

      resolve(fn _parent, args, _ ->
        Repo.get!(Product, args.id)
        |> Product.changeset(args.input)
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
