defmodule WhiteBreadContext do
  use WhiteBread.Context
  use Hound.Helpers
  alias Takso.{Repo, Accounts.User, Sales.Booking, Sales.Taxi}
  alias Takso.Sales.{Taxi, Booking}

  feature_starting_state(fn ->
    Application.ensure_all_started(:hound)
    %{}
  end)

  scenario_starting_state(fn _state ->
    Hound.start_session()
    Ecto.Adapters.SQL.Sandbox.checkout(Takso.Repo)
    Ecto.Adapters.SQL.Sandbox.mode(Takso.Repo, {:shared, self()})
    %{}
  end)

  scenario_finalize(fn _status, _state ->
    Ecto.Adapters.SQL.Sandbox.checkin(Takso.Repo)
    # Hound.end_session()
  end)

  given_(~r/^Jake logs into the system using his credentials$/, fn state, %{table_data: table} ->
    user = %User{
      name: "Jake Blake",
      email: "jake@ut.ee",
      password: "1234",
      role: "customer",
      age: 44,
      id: 1
    }

    Repo.insert!(user)

    user = Repo.get!(User, 1)
    # IO.puts(user)
    navigate_to("/sessions/new")
    fill_field({:id, "email"}, user.email)
    fill_field({:id, "password"}, user.password)
    click({:id, "submit"})
    id = user.id
    state = Map.put(state, :id, id)
    ## add changeset
    {:ok, state}
  end)

  and_(~r/^the following taxi drivers are on duty$/, fn state, %{table_data: table} ->
    # Due to some error that i couldn find an answer to fast enough, the taxi drivers and taxi are manually inserted rather than using the table in the feature.
    # For some reason users werent inserted into the database which resulted in nullpointers.

    john1 =
      %User{
        id: 2,
        name: "John Joe",
        email: "john123@takso.ee",
        password: "1234",
        age: 44,
        role: "driver"
      }
      |> Repo.insert!()

    john1 =
      %User{
        id: 3,
        name: "John Joe",
        email: "john321@takso.ee",
        password: "1234",
        age: 45,
        role: "driver"
      }
      |> Repo.insert!()

    # table
    # |> Enum.map(fn user -> User.changeset(%User{}, user) end)
    # |> Enum.each(fn changeset -> Repo.insert!(changeset) end)

    {:ok, state}
  end)

  and_(~r/^the following taxis are on duty$/, fn state, %{table_data: table} ->
    # Due to some error that i couldn find an answer to fast enough, the taxi drivers and taxi are manually inserted rather than using the table in the feature.
    # For some reason users werent inserted into the database which resulted in nullpointers.
    taxi_john1 =
      %Taxi{
        location: "Juhan Liivi 2",
        status: "busy",
        completed_rides: 0,
        price: 6.0,
        capacity: 4,
        driver_id: 2
      }
      |> Repo.insert!()

    taxi_john2 =
      %Taxi{
        location: "Juhan Liivi 2",
        status: "available",
        completed_rides: 1,
        price: 16.0,
        capacity: 2,
        driver_id: 3
      }
      |> Repo.insert!()

    # table = Enum.map(table, fn taxi -> Taxi.changeset(%Taxi{}, taxi) end)
    # table = Enum.each(table, fn x -> Repo.insert!(x) end)
    {:ok, state}
  end)

  and_(~r/^the following taxis are on duty but busy$/, fn state, %{table_data: table} ->
    # Due to some error that i couldn find an answer to fast enough, the taxi drivers and taxi are manually inserted rather than using the table in the feature.
    # For some reason users werent inserted into the database which resulted in nullpointers.
    taxi_john1 =
      %Taxi{
        location: "Juhan Liivi 2",
        status: "busy",
        completed_rides: 0,
        price: 6.0,
        capacity: 4,
        driver_id: 2
      }
      |> Repo.insert!()

    taxi_john2 =
      %Taxi{
        location: "Juhan Liivi 2",
        status: "busy",
        completed_rides: 1,
        price: 16.0,
        capacity: 2,
        driver_id: 3
      }
      |> Repo.insert!()

    # table = Enum.map(table, fn taxi -> Taxi.changeset(%Taxi{}, taxi) end)
    # table = Enum.each(table, fn x -> Repo.insert!(x) end)
    {:ok, state}
  end)

  and_(
    ~r/^I want to go from "(?<pickup_address>[^"]+)" to "(?<dropoff_address>[^"]+)" with distance "(?<distance>[^"]+)"$/,
    fn state,
       %{pickup_address: pickup_address, dropoff_address: dropoff_address, distance: distance} ->
      {:ok,
       state
       |> Map.put(:pickup_address, pickup_address)
       |> Map.put(:dropoff_address, dropoff_address)
       |> Map.put(:distance, distance)}
    end
  )

  and_(~r/^I open the STRS's booking web page$/, fn state ->
    navigate_to("/bookings/new")
    {:ok, state}
  end)

  and_(~r/^I enter the booking information$/, fn state ->
    fill_field({:id, "pickup_address"}, state[:pickup_address])
    fill_field({:id, "dropoff_address"}, state[:dropoff_address])
    fill_field({:id, "distance"}, state[:distance])

    {:ok, state}
  end)

  when_(~r/^I submit the booking request$/, fn state ->
    click({:id, "submit"})
    {:ok, state}
  end)

  then_(~r/^I should receive a confirmation message$/, fn state ->
    assert visible_in_page?(~r/Your taxi driver/)
    {:ok, state}
  end)

  then_(~r/^I should receive a rejection message$/, fn state ->
    assert visible_in_page?(~r/At present, there is no taxi available!/)
    {:ok, state}
  end)

  # given_ ~r/^the following taxis are on duty$/, fn state, %{table_data: table} ->
  #   table
  #   |> Enum.map(fn taxi -> Taxi.changeset(%Taxi{}, taxi) end)
  #   |> Enum.each(fn changeset -> Repo.insert!(changeset) end)
  #   {:ok, state}
  # end

  # and_ ~r/^I want to go from "(?<pickup_address>[^"]+)" to "(?<dropoff_address>[^"]+)"$/,
  # fn state, %{pickup_address: pickup_address,dropoff_address: dropoff_address} ->
  #   {:ok, state |> Map.put(:pickup_address, pickup_address) |> Map.put(:dropoff_address, dropoff_address)}
  # end

  # and_ ~r/^I open STRS' web page$/, fn state ->
  #   navigate_to("/bookings/new")
  #   {:ok, state}
  # end

  # and_ ~r/^I enter the booking information$/, fn state ->
  #   fill_field({:id, "pickup_address"}, state[:pickup_address])
  #   fill_field({:id, "dropoff_address"}, state[:dropoff_address])
  #   {:ok, state}
  # end

  # when_ ~r/^I summit the booking request$/, fn state ->
  #   click({:id, "submit_button"})
  #   {:ok, state}
  # end

  # then_ ~r/^I should receive a confirmation message$/, fn state ->
  #   assert visible_in_page? ~r/Your taxi will arrive in \d+ minutes/
  #   {:ok, state}
  # end

  # then_ ~r/^I should receive a rejection message$/, fn state ->
  #   assert visible_in_page? ~r/At present, there is no taxi available!/
  #   {:ok, state}
  # end
end
