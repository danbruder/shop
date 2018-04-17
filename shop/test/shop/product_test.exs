defmodule ShopWeb.ProductTest do
  use ShopWeb.ConnCase, async: true
  import Ecto.Query
  alias Shop.{Product, Repo}

  setup do
    Shop.Seeds.run()
  end

  @query """
  mutation{
    createProduct(input: {title:"New Product!" }){title categories{name}}
  }
  """
  test "Create a product", %{conn: conn} do
    conn = post(conn, "/graphql", query: @query)

    assert json_response(conn, 200) == %{
             "data" => %{
               "createProduct" => %{
                 "title" => "New Product!"
               }
             }
           }
  end

  @query """
  mutation{
    createProduct(input: {title:"New Product!", categories: [{name: "New category"}]}){title categories{name}}
  }
  """
  test "Create a product with category", %{conn: conn} do
    conn = post(conn, "/graphql", query: @query)

    assert json_response(conn, 200) == %{
             "data" => %{
               "createProduct" => %{
                 "title" => "New Product!",
                 "categories" => [
                   %{"name" => "New category"}
                 ]
               }
             }
           }
  end

  @query """
  {
    allProducts{title}
  }
  """
  test "List products", %{conn: conn} do
    conn = post(conn, "/graphql", query: @query)

    assert json_response(conn, 200) == %{
             "data" => %{
               "allProducts" => [
                 %{
                   "title" => "Some Test Product"
                 }
               ]
             }
           }
  end

  @query """
  mutation UpdateProductMutation($id: Int!, $input: ProductInput!){
    updateProduct(id: $id, input: $input){
      title
    }
  }
  """
  test "Update Product", %{conn: conn} do
    title = "UPDATED"
    id = Repo.one(from(x in Product, order_by: [desc: x.id], limit: 1, select: x.id))

    conn =
      post(
        conn,
        "/graphql",
        query: @query,
        variables: %{"id" => id, "input" => %{"title" => title}}
      )

    assert json_response(conn, 200) == %{
             "data" => %{
               "updateProduct" => %{
                 "title" => "UPDATED"
               }
             }
           }
  end

  @query """
  mutation DeleteProductMutation($id: Int!){
    deleteProduct(id: $id)
  }
  """
  test "Delete Product", %{conn: conn} do
    id = Repo.one(from(x in Product, order_by: [desc: x.id], limit: 1, select: x.id))
    conn = post(conn, "/graphql", query: @query, variables: %{"id" => id})

    assert json_response(conn, 200) == %{
             "data" => %{
               "deleteProduct" => "#{id}"
             }
           }
  end
end
