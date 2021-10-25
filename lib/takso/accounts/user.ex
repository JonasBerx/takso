defmodule Takso.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    # Email is used as username
    field :email, :string
    field :password, :string
    field :age, :integer

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :email, :password, :age])
    |> validate_required([:name, :email, :password, :age])
  end
end
