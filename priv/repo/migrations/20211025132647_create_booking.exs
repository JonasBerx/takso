defmodule Takso.Repo.Migrations.CreateBooking do
  use Ecto.Migration

  def change do
    create table(:booking) do
      add :pickup_address, :string
      add :dropoff_address, :string
      add :status, :string

      timestamps()
    end
  end
end
