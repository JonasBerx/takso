defmodule Takso.Sales.Taxi do
  use Ecto.Schema
  import Ecto.Changeset

  schema "taxis" do
    field(:location, :string)
    field(:status, :string)
    field(:completed_rides, :integer)
    field(:price, :float)
    field(:capacity, :integer)
    belongs_to(:driver, Takso.Accounts.User)
    # timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [
      :driver_id,
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
