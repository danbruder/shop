defmodule Shop.Seeds do
  alias Shop.{Product, Category, Repo}

  def run do
    %Product{}
    |> Product.changeset(%{title: "Some Test Product"})
    |> Repo.insert()

    %Category{}
    |> Category.changeset(%{name: "Category 1"})
    |> Repo.insert()

    :ok
  end
end
