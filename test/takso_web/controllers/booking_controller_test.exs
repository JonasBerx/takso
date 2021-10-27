defmodule Takso.BookingControllerTest do
  use TaksoWeb.ConnCase

  alias Takso.{Repo, Sales.Taxi}
  # TODO : Booking rejection
  # Insert user that wants to book ride
  # Insert taxi that is busy
  # Call booking function with params
  # Assert html response to be rejection message
  test "Booking rejection", %{conn: conn} do
    Repo.insert!(%Taxi{name: "jonas", price: 2.0, status: "available"})

    conn =
      post conn, "/bookings", %{
        booking: [pickup_address: "Liivi 2", dropoff_address: "Lõunakeskus", status: ""]
      }

    conn = get(conn, redirected_to(conn))
    assert html_response(conn, 200) =~ ~r/At present, there is no taxi available!/
  end

  # TODO : Booking acceptance ~ default path
  # Insert user that wants to book ride
  # Insert taxi that is available
  # Call booking function with params
  # Assert html response to be rejection message
  test "Booking acceptance", %{conn: conn} do
    Repo.insert!(%Taxi{name: "jonas", price: 2.0, status: "busy"})
    Repo.insert!(%Taxi{name: "juhan", price: 2.0, status: "available"})

    conn =
      post conn, "/bookings", %{
        booking: [pickup_address: "Liivi 2", dropoff_address: "Lõunakeskus", status: ""]
      }

    conn = get(conn, redirected_to(conn))
    assert html_response(conn, 200) =~ ~r/Your taxi driver, juhan, will arrive shortly/
  end

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

  # TODO : Booking rejection ~ negative distance
  # Insert user that wants to book ride
  # Insert taxi that is available
  # Call booking function with params
  # Assert html response to be the form with an error message
end
