defmodule Servy.FourOhFourCounter do

  @name :four_oh_four_counter

  use GenServer

  # Client Interface

  def start_link(_arg) do
    IO.puts "Starting FourOhFourCounter..."
    GenServer.start_link(__MODULE__, %{}, name: @name)
  end

  def stop do
    IO.puts "Stopping FourOhFourCounter..."
    GenServer.stop(@name)
  end

  def bump_count(path) do
    GenServer.call @name, {:bump_count, path}
  end

  def get_count(path) do
    GenServer.call @name, {:get_count, path}
  end

  def get_counts do
    GenServer.call @name, :get_counts
  end

  def clear do
    GenServer.cast @name, :clear
  end

  # Server Callbacks

  def init(_args) do
    {:ok, %{}}
  end

  def handle_call({:bump_count, path}, _from, state) do
    new_state = Map.update(state, path, 1, &(&1 + 1))
    {:reply, :ok, new_state}
  end

  def handle_call({:get_count, path}, _from, state) do
    count = Map.get(state, path, 0)
    {:reply, count, state}
  end

  def handle_call(:get_counts, _from, state) do
    {:reply, state, state}
  end

  def handle_cast(:clear, _from, _state) do
    IO.puts "Clearing counts..."
    {:noreply, %{}}
  end

  def handle_info(message, state) do
    IO.puts "Ooops: #{inspect(message)}"
    {:noreply, state}
  end
end
