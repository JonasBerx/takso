defmodule Takso.Sales.Booking do
  use Ecto.Schema
  import Ecto.Changeset

  schema "booking" do
    field :dropoff_address, :string
    field :pickup_address, :string
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(booking, attrs) do
    booking
    |> cast(attrs, [:pickup_address, :dropoff_address, :status])

    # |> validate_required([:pickup_address, :dropoff_address])
  end
end
