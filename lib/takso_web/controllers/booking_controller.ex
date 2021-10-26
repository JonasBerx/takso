defmodule TaksoWeb.BookingController do
  use TaksoWeb, :controller

  import Ecto.Query, only: [from: 2]
  alias Takso.Sales.Taxi
  alias Takso.Sales.Booking
  alias Takso.{Repo, Sales.Booking}

  def index(conn, _params) do
    bookings = Repo.all(Booking)
    render(conn, "index.html", bookings: bookings)
  end

  def new(conn, _params) do
    changeset = Booking.changeset(%Booking{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"booking" => booking_params}) do
    query = from t in Taxi, where: t.status == "available", select: t
    available_taxis = Takso.Repo.all(query)

    case length(available_taxis) > 0 do
      true ->
        changeset = Booking.changeset(%Booking{}, booking_params)
        changeset = Ecto.Changeset.put_change(changeset, :status, "ACCEPTED")

        case Repo.insert(changeset) do
          {:ok, _booking} ->
            # TODO find cheapest and least driven taxi and assign here.
            driver = Enum.filter(available_taxis, fn x -> x.completed_rides == 0 end)

            output =
              "Your taxi driver, " <>
                to_string(Enum.at(driver, 0).name) <> ", will arrive shortly."

            conn
            |> put_flash(:info, output)
            |> redirect(to: Routes.booking_path(conn, :index))

          {:error, changeset} ->
            render(conn, "new.html", changeset: changeset)
        end

      _ ->
        changeset = Booking.changeset(%Booking{}, booking_params)
        changeset = Ecto.Changeset.put_change(changeset, :status, "REJECTED")
        Repo.insert!(changeset)

        conn
        |> put_flash(:info, "At present, there is no taxi available!")
        |> redirect(to: Routes.booking_path(conn, :new))
    end
  end

  def delete(conn, %{"id" => id}) do
    booking = Repo.get!(Booking, id)
    Repo.delete!(booking)

    conn
    |> put_flash(:info, "Booking deleted successfully.")
    |> redirect(to: Routes.booking_path(conn, :index))
  end
end
