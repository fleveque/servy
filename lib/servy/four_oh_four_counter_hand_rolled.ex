defmodule Servy.FourOhFourCounterHandRolled do

  @name :four_oh_four_counter_hand_rolled

  alias Servy.GenericServer

  # Client Interface

  def start do
    IO.puts "Starting FourOhFourCounter..."
    GenericServer.start(__MODULE__, @name, %{})
  end

  def stop do
    IO.puts "Stopping FourOhFourCounter..."
    GenericServer.stop(@name)
  end

  def bump_count(path) do
    GenericServer.call @name, {:bump_count, path}
  end

  def get_count(path) do
    GenericServer.call @name, {:get_count, path}
  end

  def get_counts do
    GenericServer.call @name, :get_counts
  end

  def clear do
    GenericServer.cast @name, :clear
  end

  # Server Callbacks

  def handle_call({:bump_count, path}, state) do
    new_state = Map.update(state, path, 1, &(&1 + 1))
    {Map.get(new_state, path), new_state}
  end

  def handle_call({:get_count, path}, state) do
    count = Map.get(state, path, 0)
    {count, state}
  end

  def handle_call(:get_counts, state) do
    {state, state}
  end

  def handle_cast(:clear, _state) do
    IO.puts "Clearing counts..."
    %{}
  end
end
