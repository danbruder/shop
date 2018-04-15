defmodule Shop.Schema do
  use Absinthe.Schema
  import_types(Shop.ProductApi)
  import_types(Shop.CategoryApi)

  query do
    import_fields(:product_queries)
    import_fields(:category_queries)

    field :hello, :string do
      resolve(fn _, _ -> {:ok, "world"} end)
    end
  end

  mutation do
    import_fields(:product_mutations)
    import_fields(:category_mutations)
  end

  subscription do
    import_fields(:product_subscriptions)
  end
end
