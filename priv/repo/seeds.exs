alias Takso.{Repo, Accounts.User}
alias Takso.{Repo, Sales.Taxi}

[
  %{name: "Fred Flintstone", email: "fred@ut.ee", password: "parool", age: 18, role: "customer"},
  %{
    name: "Barney Rubble",
    email: "barney@taltech.ee",
    password: "parool",
    age: 21,
    role: "customer"
  },
  %{name: "juhan", email: "juhan@takso.ee", password: "password", age: 25, role: "driver"},
  %{name: "armin", email: "armin@takso.ee", password: "password", age: 21, role: "driver"}
]
|> Enum.map(fn user_data -> User.changeset(%User{}, user_data) end)
|> Enum.each(fn changeset -> Repo.insert!(changeset) end)

[
  %{
    location: "Narva mnt 25",
    status: "AVAILABLE",
    completed_rides: 0,
    price: 2.0,
    capacity: 4,
    driver_id: 3
  }
]
|> Enum.map(fn taxi_data -> Taxi.changeset(%Taxi{}, taxi_data) end)
# |> Enum.each(fn changeset -> Ecto.build_assoc(changeset, :user, %{driver_id: 3}) end)
|> Enum.each(fn changeset -> Repo.insert!(changeset) end)

[
  %{
    location: "Narva mnt 27",
    status: "available",
    completed_rides: 1,
    price: 4.0,
    capacity: 2,
    driver_id: 4
  }
]
|> Enum.map(fn taxi_data -> Taxi.changeset(%Taxi{}, taxi_data) end)
# |> Enum.each(fn changeset -> Ecto.build_assoc(changeset, :user, %{driver_id: 4}) end)
|> Enum.each(fn changeset -> Repo.insert!(changeset) end)

# taxi1 = Repo.get(Taxi, 1)
# driver1 = Ecto.build_assoc(taxi1, :driver, %{driver_id: 3})
# Repo.insert!(driver1)
# taxi2 = Repo.get(Taxi, 2)
# driver2 = Ecto.build_assoc(taxi2, :driver, %{driver_id: 4})
# Repo.insert!(driver2)
