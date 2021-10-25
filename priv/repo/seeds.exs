alias Takso.{Repo, Accounts.User}
alias Takso.{Repo, Sales.Taxi}

[
  %{name: "Fred Flintstone", email: "fred@ut.ee", password: "parool", age: 18},
  %{name: "Barney Rubble", email: "barney@taltech.ee", password: "parool", age: 21}
]
|> Enum.map(fn user_data -> User.changeset(%User{}, user_data) end)
|> Enum.each(fn changeset -> Repo.insert!(changeset) end)

[
  %{
    name: "juhan",
    email: "juhan@takso.ee",
    age: 25,
    password: "password",
    location: "Narva mnt 25",
    status: "available",
    completed_rides: 0,
    price: 2.0,
    capacity: 4
  },
  %{
    name: "armin",
    email: "armin@takso.ee",
    age: 23,
    password: "password",
    location: "Narva mnt 27",
    status: "available",
    completed_rides: 1,
    price: 4.0,
    capacity: 2
  }
]
|> Enum.map(fn taxi_data -> Taxi.changeset(%Taxi{}, taxi_data) end)
|> Enum.each(fn changeset -> Repo.insert!(changeset) end)
