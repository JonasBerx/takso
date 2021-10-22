alias Takso.{Repo, Accounts.User}

[
  %{name: "Fred Flintstone", username: "fred", password: "parool"},
  %{name: "Barney Rubble", username: "barney", password: "parool"}
]
|> Enum.map(fn user_data -> User.changeset(%User{}, user_data) end)
|> Enum.each(fn changeset -> Repo.insert!(changeset) end)
