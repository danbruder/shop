defmodule ShopWeb.PageController do
  use ShopWeb, :controller
  use Absinthe.Phoenix.Controller, schema: Shop.Schema

  @graphql """
  query {
    allProducts{
      title
      price
  categories { 
    name
  }
    }
  }
  """
  def index(conn, %{data: data}) do
    render(conn, "index.html", data)
  end
end
