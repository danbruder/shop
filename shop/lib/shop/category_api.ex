defmodule Shop.CategoryApi do
  use Absinthe.Ecto, repo: Shop.Repo
  use Absinthe.Schema.Notation
  alias Shop.Repo
  alias Shop.Category

  @doc """
  Graphql category object
  """
  object :category do
    field(:id, :integer)
    field(:name, :string)
    field(:products, list_of(:product), resolve: assoc(:products))
  end

  input_object :category_input do
    field(:name, :string)
  end

  object :category_queries do
    field :all_categories, list_of(:category) do
      resolve(fn _, _, _ ->
        results = Repo.all(Category)
        {:ok, results}
      end)
    end
  end

  object :category_mutations do
    field :create_category, :category do
      arg(:name, non_null(:string))

      resolve(fn _parent, args, _ ->
        %Category{}
        |> Category.changeset(args)
        |> Repo.insert()
      end)
    end

    field :update_category, :category do
      arg(:id, non_null(:integer))
      arg(:name, :string)

      resolve(fn _parent, args, _ ->
        Repo.get!(Category, args.id)
        |> Category.changeset(args)
        |> Repo.update()
      end)
    end

    field :delete_category, :id do
      arg(:id, non_null(:integer))

      resolve(fn _parent, args, _ ->
        Repo.get!(Category, args.id)
        |> Repo.delete()

        {:ok, args.id}
      end)
    end
  end
end
