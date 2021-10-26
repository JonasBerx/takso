defmodule Takso.Sales.Taxi do
  use Ecto.Schema
  import Ecto.Changeset

  schema "taxis" do
    field :name, :string
    field :email, :string
    field :age, :integer
    field :password, :string
    field :location, :string
    field :status, :string
    field :completed_rides, :integer
    field :price, :float
    field :capacity, :integer
    # timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [
      :name,
      :email,
      :age,
      :password,
      :location,
      :status,
      :completed_rides,
      :price,
      :capacity
    ])

    # |> validate_required([
    #   :name,
    #   :email,
    #   :age,
    #   :password,
    #   :location,
    #   :status,
    #   :completed_rides,
    #   :price,
    #   :capacity
    # ])
  end
end
