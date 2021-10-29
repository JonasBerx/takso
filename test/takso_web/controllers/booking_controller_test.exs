defmodule Takso.BookingControllerTest do
  use TaksoWeb.ConnCase
  alias Plug.Conn
  alias Takso.{Repo, Sales.Taxi, Accounts.User}

  setup do
    armin =
      %User{
        id: 1,
        name: "armin remenyi",
        email: "armin@ut.ee",
        password: "t",
        age: 21,
        role: "customer"
      }
      |> Repo.insert!()

    conn =
      build_conn()
      |> init_test_session(%{current_user: armin, user_id: to_string(armin.id)})

    {:ok, conn: conn, user: Repo.get(User, 1)}
  end

  test "the truth" do
    assert true
  end

  describe "/POST booking" do
    setup do
      juhan =
        %User{
          id: 2,
          name: "juhan",
          email: "juhan@ut.ee",
          password: "t",
          age: 21,
          role: "driver"
        }
        |> Repo.insert!()

      taxi_juhan =
        %Taxi{
          location: "Narva mnt 25",
          status: "available",
          completed_rides: 0,
          price: 2.0,
          capacity: 4,
          driver_id: 2
        }
        |> Repo.insert!()

      {:ok, taxi: taxi_juhan}
    end

    test "with valid parameters, books a taxi", %{conn: conn} do
      conn =
        post(conn, "/bookings", %{
          booking: [
            pickup_address: "Liivi 2",
            dropoff_address: "Lõunakeskus",
            status: "",
            distance: "5.0"
          ]
        })

      conn = get(conn, redirected_to(conn))
      assert html_response(conn, 200) =~ ~r/Your taxi driver juhan will arrive soon./
    end

    test "with valid parameters, show confirmation message and the cheapest taxi", %{conn: conn} do
      martin =
        %User{
          id: 3,
          name: "martin",
          email: "martin@ut.ee",
          password: "t",
          age: 21,
          role: "driver"
        }
        |> Repo.insert!()

      taxi_martin =
        %Taxi{
          location: "Narva mnt 25",
          status: "available",
          completed_rides: 1,
          price: 1.0,
          capacity: 4,
          driver_id: 3
        }
        |> Repo.insert!()

      path =
        post(conn, "/bookings", %{
          booking: [
            pickup_address: "Liivi 2",
            dropoff_address: "Lõunakeskus",
            status: "",
            distance: "5.0"
          ]
        })

      path = get(path, redirected_to(path))
      assert html_response(path, 200) =~ ~r/The total price for the ride is €5./
    end

    test "with valid parameters, book the cheapest and least used taxi", %{conn: conn} do
      martin =
        %User{
          id: 3,
          name: "martin",
          email: "martin@ut.ee",
          password: "t",
          age: 21,
          role: "driver"
        }
        |> Repo.insert!()

      taxi_martin =
        %Taxi{
          location: "Narva mnt 25",
          status: "available",
          completed_rides: 1,
          price: 2.0,
          capacity: 4,
          driver_id: 3
        }
        |> Repo.insert!()

      conn =
        post(conn, "/bookings", %{
          booking: [
            pickup_address: "Liivi 2",
            dropoff_address: "Lõunakeskus",
            status: "",
            distance: "5.0"
          ]
        })

      conn = get(conn, redirected_to(conn))
      assert html_response(conn, 200) =~ ~r/Your taxi driver juhan will arrive soon./
    end

    # test "no taxi drivers are available, show rejection message" %{conn: conn, taxi: taxi_juhan} do
    #   IO.puts(taxi_juhan)
    # end

    test "with empty pickup address, show rejection message", %{conn: conn} do
      conn =
        post(conn, "/bookings", %{
          booking: [
            pickup_address: "",
            dropoff_address: "Lõunakeskus",
            status: "",
            distance: "5.0"
          ]
        })

      assert html_response(conn, 200) =~ ~r/Pickup and dropoff address can&#39;t be empty./
    end

    test "with empty dropoff address, show rejection message", %{conn: conn} do
      conn =
        post(conn, "/bookings", %{
          booking: [
            pickup_address: "Lõunakeskus",
            dropoff_address: "",
            status: "",
            distance: "5.0"
          ]
        })

      assert html_response(conn, 200) =~ ~r/Pickup and dropoff address can&#39;t be empty./
    end

    test "with negative distance, show rejection message", %{conn: conn} do
      conn =
        post(conn, "/bookings", %{
          booking: [
            pickup_address: "Liivi 2",
            dropoff_address: "Lõunakeskus",
            status: "",
            distance: "-5.0"
          ]
        })

      assert html_response(conn, 200) =~ ~r/Distance cannot be negative./
    end
  end

  # TODO : Booking rejection
  # Insert user that wants to book ride
  # Insert taxi that is busy
  # Call booking function with params
  # Assert html response to be rejection message

  # TODO : Booking acceptance ~ default path
  # Insert user that wants to book ride
  # Insert taxi that is available
  # Call booking function with params
  # Assert html response to be rejection message

  # TODO : Booking acceptance ~ 2 taxis with same price gives taxi with lowest amount of rides.
  # Insert user that wants to book ride
  # Insert two taxis that are available and have the same price
  # Call booking function with params
  # Assert html response to be acceptance message

  # TODO : Booking acceptance ~ 2 taxis with different price gives taxi with lowest price.
  # Insert user that wants to book ride
  # Insert two taxis that are available and have a respective price.
  # Call booking function with params
  # Assert html response to be acceptance message

  # TODO : Booking rejection ~ pickup_address is not filled in
  # Call booking function with params
  # Assert html response to be the form with an error message

  # TODO : Booking rejection ~ dropoff_address is not filled in
  # Insert user that wants to book ride
  # Insert taxi that is available
  # Call booking function with params
  # Assert html response to be the form with an error message

  # TODO : Booking rejection ~ negative distance
  # Insert user that wants to book ride
  # Insert taxi that is available
  # Call booking function with params
  # Assert html response to be the form with an error message
end
