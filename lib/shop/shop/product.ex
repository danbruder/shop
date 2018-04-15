defmodule Shop.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field(:description, :string)
    field(:image, :string)
    field(:price, :float)
    field(:title, :string)

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:title, :description, :price, :image])
    |> validate_required([:title])
  end
end
