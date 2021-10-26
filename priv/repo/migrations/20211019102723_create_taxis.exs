defmodule Takso.Repo.Migrations.CreateTaxis do
  use Ecto.Migration

  def change do
    create table(:taxis) do
      add :location, :string
      add :status, :string
      add :completed_rides, :integer
      add :price, :float
      add :capacity, :integer
      add :driver_id, references(:users)
      # timestamps()
    end
  end
end
