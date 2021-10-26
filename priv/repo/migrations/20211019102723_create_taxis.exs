defmodule Takso.Repo.Migrations.CreateTaxis do
  use Ecto.Migration

  def change do
    create table(:taxis) do
      add :name, :string
      add :email, :string
      add :age, :integer
      add :password, :string
      add :location, :string
      add :status, :string
      add :completed_rides, :integer
      add :price, :float
      add :capacity, :integer
      # timestamps()
    end
  end
end
