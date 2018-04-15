defmodule Shop.Schema do
  use Absinthe.Schema
  import_types(Shop.ProductApi)

  query do
    import_fields(:product_queries)

    field :hello, :string do
      resolve(fn _, _ -> {:ok, "world"} end)
    end
  end

  mutation do
    import_fields(:product_mutations)
  end
end
