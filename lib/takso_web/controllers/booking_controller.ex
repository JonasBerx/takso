defmodule TaksoWeb.BookingController do
  use TaksoWeb, :controller

  import Ecto.Query, only: [from: 2]
  alias Takso.Sales.{Taxi, Booking, Allocation}
  alias Takso.Accounts.{User}
  alias Takso.Sales.Allocation
  alias Ecto.{Changeset, Multi}
  alias Takso.{Repo, Sales.Booking}

  def index(conn, _params) do
    user = conn.assigns.current_user

    case user do
      nil ->
        conn
        |> put_flash(:error, "You are not logged in. Please log in")
        |> redirect(to: Routes.session_path(conn, :new))

      _ ->
        case user.role do
          "customer" ->
            bookings =
              Repo.all(from b in Booking, where: b.user_id == ^conn.assigns.current_user.id)

            render(conn, "index.html", bookings: bookings)

          _ ->
            # select * from allocations a
            # inner join taxis t on a.taxi_id = t.id
            # inner join users u on u.id = t.driver_id
            query =
              from a in Allocation,
                join: t in Taxi,
                on: t.id == a.taxi_id,
                join: u in User,
                on: u.id == t.driver_id,
                join: b in Booking,
                on: a.booking_id == b.id,
                group_by: [t.id, b.id],
                where: u.id == ^user.id,
                select: b

            bookings = Repo.all(query)

            render(conn, "index.html", bookings: bookings)
        end
    end
  end

  def new(conn, _params) do
    changeset = Booking.changeset(%Booking{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"booking" => booking_params}) do
    user = conn.assigns.current_user
    # TODO check if distance is not negative.
    # TODO check if pickup and dropoff are not the same
    case user do
      nil ->
        conn
        |> put_flash(:error, "You are not logged in. Please log in")
        |> redirect(to: Routes.session_path(conn, :new))

      _ ->
        mapped =
          Enum.map(booking_params, fn {key, value} -> {String.to_atom(key), value} end)
          |> Map.new()

        booking_struct =
          Ecto.build_assoc(
            user,
            :bookings,
            mapped
          )

        {v, _} = Float.parse(booking_params["distance"])
        IO.puts(v)

        changeset =
          Booking.changeset(booking_struct, %{})
          |> Changeset.put_change(:status, "open")
          |> Changeset.put_change(:distance, v)

        if Map.get(mapped, :pickup_address) === "" || Map.get(mapped, :dropoff_address) === "" do
          conn
          |> put_flash(:error, "Pickup and dropoff address can't be empty")
          |> render("new.html", changeset: changeset)
        else
          if v <= 0.0 do
            conn
            |> put_flash(:error, "Distance cannot be negative or zero")
            |> render("new.html", changeset: changeset)
          else
            if Map.get(mapped, :pickup_address) === Map.get(mapped, :dropoff_address) do
              conn
              |> put_flash(:error, "Pickup and dropoff address can't be the same")
              |> render("new.html", changeset: changeset)
            else
              booking = Repo.insert!(changeset)
              # Assign taxi with lowest price and lowest amount of rides.\
              query =
                from t in Taxi,
                  where: t.status == "available",
                  select: t,
                  order_by: [t.price, t.completed_rides]

              assigned_driver = Takso.Repo.all(query)

              case length(assigned_driver) > 0 do
                true ->
                  taxi = List.first(assigned_driver)

                  Multi.new()
                  |> Multi.insert(
                    :allocation,
                    Allocation.changeset(%Allocation{}, %{status: "accepted"})
                    |> Changeset.put_change(:booking_id, booking.id)
                    |> Changeset.put_change(:taxi_id, taxi.id)
                  )
                  |> Multi.update(
                    :taxi,
                    Taxi.changeset(taxi, %{}) |> Changeset.put_change(:status, "busy")
                  )
                  |> Multi.update(
                    :booking,
                    Booking.changeset(booking, %{})
                    |> Changeset.put_change(:status, "allocated")
                  )
                  |> Repo.transaction()

                  get_driver = Repo.get!(User, taxi.driver_id)
                  total_price = v * taxi.price

                  conn
                  |> put_flash(
                    :info,
                    "Your taxi driver " <>
                      get_driver.name <>
                      " will arrive soon.\n(Currently at: " <>
                      taxi.location <>
                      ")\nThe taxi has " <>
                      Integer.to_string(taxi.capacity) <>
                      " seats.\nThe total cost of the ride will be €" <>
                      Float.to_string(total_price)
                  )
                  |> redirect(to: Routes.booking_path(conn, :index))

                _ ->
                  Multi.new()
                  |> Multi.insert(
                    :allocation,
                    Allocation.changeset(%Allocation{}, %{})
                    |> Changeset.put_change(:booking_id, booking.id)
                  )
                  |> Multi.update(
                    :booking,
                    Booking.changeset(booking, %{})
                    |> Changeset.put_change(:status, "rejected")
                  )
                  |> Repo.transaction()

                  conn
                  |> put_flash(:info, "At present, there is no taxi available!")
                  |> redirect(to: Routes.booking_path(conn, :index))
              end
            end
          end
        end
    end
  end

  def summary(conn, _params) do
    query =
      from t in Taxi,
        join: a in Allocation,
        on: t.id == a.taxi_id,
        join: u in Takso.Accounts.User,
        on: t.id == u.id,
        group_by: t.id,
        where: a.status == "accepted",
        select: {t.id, count(a.id)}

    render(conn, "summary.html", tuples: Repo.all(query))
  end

  def delete(conn, %{"id" => id}) do
    booking = Repo.get!(Booking, id)
    Repo.delete!(booking)

    conn
    |> put_flash(:info, "Booking deleted successfully.")
    |> redirect(to: Routes.booking_path(conn, :index))
  end

  # select name, pickup_address, dropoff_address, b.status from bookings b
  # inner join allocations a on b.id = a.booking_id
  # inner join taxis t on a.taxi_id = t.id
  # inner join users u on u.id = t.driver_id

  def show(conn, %{"id" => id}) do
    IO.puts(Repo.get!(Booking, id).status === "rejected")

    if Repo.get!(Booking, id).status === "rejected" do
      query_rejected =
        from b in Booking,
          group_by: [
            b.pickup_address,
            b.dropoff_address,
            b.status,
            b.distance
          ],
          where: b.id == ^id,
          select: {b.pickup_address, b.dropoff_address, b.status, b.distance}

      render(conn, "show.html", rejbooking: Repo.all(query_rejected))
    else
      query_allocated =
        from b in Booking,
          join: a in Allocation,
          on: b.id == a.booking_id,
          join: t in Taxi,
          on: t.id == a.taxi_id,
          join: u in User,
          on: u.id == t.driver_id,
          group_by: [
            t.id,
            b.pickup_address,
            b.dropoff_address,
            t.price,
            u.name,
            b.status,
            b.distance
          ],
          where: b.id == ^id,
          select: {b.pickup_address, b.dropoff_address, t.price, u.name, b.status, b.distance}

      render(conn, "show.html", accbooking: Repo.all(query_allocated))
    end
  end
end
