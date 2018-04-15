defmodule Shop.Seeds do
  alias Shop.{Product, Repo}

  def run do
    %Product{}
    |> Product.changeset(%{title: "Some Test Product"})
    |> Repo.insert()

    :ok
  end
end
