defmodule Servy.PledgeServer do

  @name :pledge_server

  # Client Interface

  def start(initial_state \\ []) do
    IO.puts "Starting PledgeServer..."
    # Ensure no process is registered before starting
    if Process.whereis(@name) do
      Process.unregister(@name)
    end
    pid = spawn(__MODULE__, :listen_loop, [initial_state])
    Process.register(pid, @name)
    pid
  end

  def stop do
    if pid = Process.whereis(@name) do
      Process.exit(pid, :normal)
    end
    :ok
  end

  def create_pledge(name, amount) do
    call @name, {:create_pledge, name, amount}
  end

  def recent_pledges do
    call @name, :recent_pledges
  end

  def total_pledged do
    call @name, :total_pledged
  end

  def clear do
    cast @name, :clear
  end

  # Helper functions

  def call(pid, message) do
    send pid, {:call, self(), message}

    receive do {:response, response} -> response end
  end

  def cast(pid, message) do
    send pid, {:cast, message}
  end

  # Server

  def listen_loop(state) do
    receive do
      {:call, sender, message} when is_pid(sender) ->
        {response, new_state} = handle_call(message, state)
        send sender, {:response, response}
        listen_loop(new_state)

      {:cast, message} ->
        new_state = handle_cast(message, state)
        listen_loop(new_state)

      unexpected ->
        IO.puts "Unexpected message: #{inspect unexpected}"
        listen_loop(state)
    end
  end

  def handle_call({:create_pledge, name, amount}, state) do
    {:ok, id} = send_pledge_to_service(name, amount)
    most_recent_pledges = Enum.take(state, 2)
    new_state = [{name, amount} | most_recent_pledges]
    {id, new_state}
  end

  def handle_call(:recent_pledges, state) do
    {state, state}
  end

  def handle_call(:total_pledged, state) do
    total = Enum.map(state, &elem(&1, 1)) |> Enum.sum()
    {total, state}
  end

  def handle_cast(:clear, _state) do
    IO.puts "Clearing pledges..."
    []
  end

  defp send_pledge_to_service(_name, _amount) do
    # Simulate sending the pledge to an external service
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end
end

alias Servy.PledgeServer

pid = PledgeServer.start()
IO.inspect Process.whereis(:pledge_server)
IO.inspect Process.registered() |> Enum.count()

IO.inspect PledgeServer.create_pledge "larry", 10
IO.inspect PledgeServer.create_pledge "curly", 30
IO.inspect PledgeServer.create_pledge "daisy", 40
IO.inspect PledgeServer.create_pledge "grace", 50
IO.inspect PledgeServer.create_pledge "moe", 20

IO.inspect PledgeServer.recent_pledges
IO.inspect PledgeServer.total_pledged

PledgeServer.clear()

IO.inspect PledgeServer.recent_pledges
IO.inspect PledgeServer.total_pledged

IO.inspect send pid, {:stop, "Unexpected message"}
IO.inspect Process.info(pid, :messages)
