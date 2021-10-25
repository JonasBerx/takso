alias Takso.{Repo, Accounts.User}
alias Takso.{Repo, Sales.Taxi}

[
  %{name: "Fred Flintstone", username: "fred", password: "parool"},
  %{name: "Barney Rubble", username: "barney", password: "parool"}
]
|> Enum.map(fn user_data -> User.changeset(%User{}, user_data) end)
|> Enum.each(fn changeset -> Repo.insert!(changeset) end)

[
  %{username: "juhan", location: "Narva mnt 25", status: "available"},
  %{username: "armin", location: "Narva mnt 27", status: "available"}
]
|> Enum.map(fn taxi_data -> Taxi.changeset(%Taxi{}, taxi_data) end)
|> Enum.each(fn changeset -> Repo.insert!(changeset) end)
