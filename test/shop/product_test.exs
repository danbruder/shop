defmodule ShopWeb.ProductTest do
  use ShopWeb.ConnCase, async: true

  setup do
    Shop.Seeds.run()
  end

  @query """
  { hello }
  """
  test "Hello world", %{conn: conn} do
    conn = get(conn, "/graphql", query: @query)

    assert json_response(conn, 200) == %{"data" => %{"hello" => "world"}}
  end

  @query """
  mutation{
    createProduct(title:"New Product!"){title}
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
  mutation UpdateProductMutation(id: Int, title: String){
    updateProduct(id: $id, title: $title){
      title
    }
  }
  """
  test "Update Product", %{conn: conn} do
    title = "UPDATED"
    conn = post(conn, "/graphql", query: @query, variables: %{"id" => id, "title" => title})

    assert json_response(conn, 200) == %{
             "data" => %{
               "updateProduct" => [
                 %{
                   "title" => "UPDATED"
                 }
               ]
             }
           }
  end
end
