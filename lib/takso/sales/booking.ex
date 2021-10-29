defmodule Takso.Sales.Booking do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bookings" do
    field(:pickup_address, :string)
    field(:dropoff_address, :string)
    field(:status, :string, default: "open")
    field(:distance, :float, default: 0.1)
    belongs_to(:user, Takso.Accounts.User)
    timestamps()
  end

  @doc false
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:pickup_address, :dropoff_address, :status, :distance])

    # |> validate_required([:pickup_address, :dropoff_address])
  end
end
