defmodule Takso.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field(:name, :string)
    # Email is used as username
    field(:email, :string)
    field(:password, :string)
    field(:age, :integer)
    field(:role, :string)
    has_many(:bookings, Takso.Sales.Booking)
    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :email, :password, :age, :role])
    |> validate_required([:name, :email, :password, :age, :role])
  end
end
