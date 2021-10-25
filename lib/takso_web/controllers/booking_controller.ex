defmodule TaksoWeb.BookingController do
  use TaksoWeb, :controller

  import Ecto.Query, only: [from: 2]
  alias Takso.Sales.Taxi
  alias Takso.Sales.Booking
  alias Takso.{Repo, Sales.Booking}

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"booking" => booking_params}) do
    query = from t in Taxi, where: t.status == "available", select: t
    available_taxis = Takso.Repo.all(query)

    case length(available_taxis) > 0 do
      true ->
        changeset = Booking.changeset(%Booking{}, booking_params)

        case Repo.insert(changeset) do
          {:ok, booking} ->
            # TODO find cheapest and least driven taxi and assign here.
            # query = from t in Taxi, select: min(t.price)
            # cheapest_taxi = Takso.Repo.all(query)

            conn
            |> put_flash(:info, "Your taxi will arrive soon")
            |> redirect(to: Routes.booking_path(conn, :new))

          {:error, changeset} ->
            render(conn, "new.html", changeset: changeset)
        end

      _ ->
        conn
        |> put_flash(:info, "At present, there is no taxi available!")
        |> redirect(to: Routes.booking_path(conn, :new))
    end
  end
end
