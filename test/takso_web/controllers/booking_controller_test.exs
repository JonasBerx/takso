defmodule Takso.BookingControllerTest do
  use TaksoWeb.ConnCase

  alias Takso.{Repo, Sales.Taxi}

  test "Booking rejection", %{conn: conn} do
    Repo.insert!(%Taxi{name: "jonas", price: 2.0, status: "available"})

    conn =
      post conn, "/bookings", %{
        booking: [pickup_address: "Liivi 2", dropoff_address: "Lõunakeskus", status: ""]
      }

    conn = get(conn, redirected_to(conn))
    assert html_response(conn, 200) =~ ~r/At present, there is no taxi available!/
  end

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
end
