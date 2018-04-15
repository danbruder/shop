defmodule Shop.Schema do
  use Absinthe.Schema
  #import_types Punch.Time.ContentTypes

  query do 
    #import_fields :log_queries
    field :hello, :string do
      resolve fn _, _ -> {:ok, "world"} end
    end
  end

  #mutation do
    #import_fields :log_mutations
  #end
end
