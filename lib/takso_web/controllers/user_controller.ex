defmodule TaksoWeb.UserController do
  use TaksoWeb, :controller

  alias Takso.{Repo, Accounts.User}

  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = User.changeset(%User{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    mapped =
      Enum.map(user_params, fn {key, value} -> {String.to_atom(key), value} end)
      |> Map.new()

    {v, _} = Integer.parse(user_params["age"])

    if 18 > v do
      conn
      |> put_flash(:error, "You are underage.")
      |> render("new.html", changeset: changeset)
    else
      if Takso.Repo.get_by(Takso.Accounts.User, email: Map.get(mapped, :email)) do
        conn
        |> put_flash(:error, "Email is already in use.")
        |> render("new.html", changeset: changeset)
      else
        case Repo.insert(changeset) do
          {:ok, user} ->
            conn
            |> put_flash(:info, "User created successfully.")
            |> redirect(to: Routes.user_path(conn, :index))

          {:error, changeset} ->
            render(conn, "new.html", changeset: changeset)
        end
      end
    end
  end

  def edit(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    changeset = User.changeset(user, %{})
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Repo.get!(User, id)
    changeset = User.changeset(user, user_params)

    Repo.update(changeset)
    redirect(conn, to: Routes.user_path(conn, :index))
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    render(conn, "show.html", user: user)
  end

  @spec delete(Plug.Conn.t(), map) :: Plug.Conn.t()
  def delete(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    Repo.delete!(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: Routes.user_path(conn, :index))
  end
end
