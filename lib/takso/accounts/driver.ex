# TODO : Should we separate taxi drivers from their taxis??

# defmodule Takso.Accounts.Driver do
#   use Ecto.Schema
#   import Ecto.Changeset

#   schema "taxi_drivers" do
#     field :age, :integer
#     field :email, :string
#     field :name, :string
#     field :password, :string

#     timestamps()
#   end

#   @doc false
#   def changeset(driver, attrs) do
#     driver
#     |> cast(attrs, [:name, :email, :age, :password])
#     |> validate_required([:name, :email, :age, :password])
#   end
# end
