defmodule Servy.SensorServer do

  @name :sensor_server
  @refresh_interval :timer.seconds(5) # Prod should be longer, e.g., :timer.minutes(60)

  use GenServer

  # Client Interface

  def start do
    GenServer.start(__MODULE__, %{}, name: @name)
  end

  def get_sensor_data do
    GenServer.call @name, :get_sensor_data
  end

  # Server Callbacks

  def init(_state) do
    initial_state = run_tasks_to_get_sensor_data()
    schedule_refresh()
    {:ok, initial_state}
  end

  def handle_call(:get_sensor_data, _from, state) do
    {:reply, state, state}
  end

  def handle_info(:refresh, _state) do
    IO.puts "Refreshing sensor data..."
    new_state = run_tasks_to_get_sensor_data()
    schedule_refresh()
    {:noreply, new_state}
  end

  defp schedule_refresh do
    Process.send_after(self(), :refresh, @refresh_interval)
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
