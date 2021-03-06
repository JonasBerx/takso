defmodule Takso.Repo.Migrations.AddUserAndStatusToBooking do
  use Ecto.Migration

  def change do
    alter table(:bookings) do
      add :status, :string, default: "rejected"
      add :user_id, references(:users)
    end
  end
end
