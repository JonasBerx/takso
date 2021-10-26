defmodule Takso.Repo.Migrations.AddTypeToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :role, :string, default: "customer"
    end
  end
end
