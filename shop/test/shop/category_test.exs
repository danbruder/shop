defmodule ShopWeb.CategoryTest do
  use ShopWeb.ConnCase, async: true
  import Ecto.Query
  alias Shop.{Category, Repo}

  setup do
    Shop.Seeds.run()
  end

  @query """
  mutation{
    createCategory(input: {name:"New Category!"}){name}
  }
  """
  test "Create a category", %{conn: conn} do
    conn = post(conn, "/graphql", query: @query)

    assert json_response(conn, 200) == %{
             "data" => %{
               "createCategory" => %{
                 "name" => "New Category!"
               }
             }
           }
  end

  @query """
  {
    allCategories{name}
  }
  """
  test "List categories", %{conn: conn} do
    conn = post(conn, "/graphql", query: @query)

    assert json_response(conn, 200) == %{
             "data" => %{
               "allCategories" => [
                 %{
                   "name" => "Category 1"
                 }
               ]
             }
           }
  end

  @query """
  mutation UpdateCategoryMutation($id: Int!, $input: CategoryInput!){
    updateCategory(id: $id, input: $input){
      name
    }
  }
  """
  test "Update Category", %{conn: conn} do
    name = "UPDATED"
    id = Repo.one(from(x in Category, order_by: [desc: x.id], limit: 1, select: x.id))

    conn =
      post(conn, "/graphql", query: @query, variables: %{"id" => id, input: %{"name" => name}})

    assert json_response(conn, 200) == %{
             "data" => %{
               "updateCategory" => %{
                 "name" => "UPDATED"
               }
             }
           }
  end

  @query """
  mutation DeleteCategoryMutation($id: Int!){
    deleteCategory(id: $id)
  }
  """
  test "Delete Category", %{conn: conn} do
    id = Repo.one(from(x in Category, order_by: [desc: x.id], limit: 1, select: x.id))
    conn = post(conn, "/graphql", query: @query, variables: %{"id" => id})

    assert json_response(conn, 200) == %{
             "data" => %{
               "deleteCategory" => "#{id}"
             }
           }
  end
end
