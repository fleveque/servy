defmodule Servy.SensorServer do

  @name :sensor_server

  use GenServer

  defmodule State do
    defstruct sensor_data: %{},
              refresh_interval: :timer.minutes(60)
  end

  # def child_spec(:frequent) do
  #   %{id: Servy.PledgeServer, restart: :permanent, shutdown: 5000,
  #   start: {Servy.PledgeServer, :start_link, [[1]]}, type: :worker}
  # end
  # def child_spec(_) do
  #   %{id: Servy.PledgeServer, restart: :permanent, shutdown: 5000,
  #   start: {Servy.PledgeServer, :start_link, [[]]}, type: :worker}
  # end

  # Client Interface

  def start_link(interval) do
    IO.puts "Starting SensorServer with #{interval} min refresh..."
    time_in_ms = :timer.minutes(interval)
    GenServer.start_link(__MODULE__, %State{refresh_interval: time_in_ms}, name: @name)
  end

  def get_sensor_data do
    GenServer.call @name, :get_sensor_data
  end

  def set_refresh_interval(time_in_ms) when is_integer(time_in_ms) and time_in_ms > 0 do
    GenServer.cast(@name, {:set_refresh_interval, time_in_ms})
  end

  def set_refresh_interval(_), do: {:error, "Invalid interval. Must be a positive integer (ms)."}

  # Server Callbacks

  def init(state) do
    sensor_state = run_tasks_to_get_sensor_data()
    initial_state = %State{state | sensor_data: sensor_state}
    schedule_refresh(state.refresh_interval)
    {:ok, initial_state}
  end

  def handle_call(:get_sensor_data, _from, state) do
    {:reply, state.sensor_data, state}
  end

  def handle_cast({:set_refresh_interval, time_in_ms}, state) do
    new_state = %State{state | refresh_interval: time_in_ms}
    {:noreply, new_state}
  end

  def handle_info(:refresh, state) do
    IO.puts "Refreshing sensor data..."
    sensor_data = run_tasks_to_get_sensor_data()
    new_state = %State{state | sensor_data: sensor_data}
    schedule_refresh(state.refresh_interval)
    {:noreply, new_state}
  end

  def handle_info(unexpected, state) do
    IO.puts "Oops! #{inspect unexpected}"
    {:noreply, state}
  end

  defp schedule_refresh(time_in_ms) do
    Process.send_after(self(), :refresh, time_in_ms)
  end

  defp run_tasks_to_get_sensor_data do
    IO.puts "Running tasks to get sensor data..."

    task = Task.async(fn -> Servy.Tracker.get_location("bigfoot") end)

    snapshots =
      ["cam-1", "cam-2", "cam-3"]
      |> Enum.map(&Task.async(fn -> Servy.VideoCam.get_snapshot(&1) end))
      |> Enum.map(&Task.await/1)

    where_is_bigfoot = Task.await(task)
    # Task.yield(task, 5000) could be used as well using a case statement
    # Task.await(task, :timer.seconds(5)) # This will wait for 5 seconds for the task to finish
    # Task.shutdown(task) # This will kill the task if it is still running
    # Task.shutdown(task, :brutal_kill) # This will kill the task immediately
    # Task.shutdown(task, :normal) # This will kill the task gracefully
    # Task.shutdown(task, :infinity) # This will wait for the task to finish

    %{snapshots: snapshots, location: where_is_bigfoot}
  end
end
