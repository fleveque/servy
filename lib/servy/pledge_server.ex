defmodule Servy.PledgeServer do
alias ElixirSense.Core.Compiler.State

  @name :pledge_server

  use GenServer #, restart: :permanent

  defmodule State do
    defstruct cache_size: 3, pledges: []
  end

  # def child_spec(_arg) do
  #   %{id: Servy.PledgeServer, restart: :permanent, shutdown: 5000,
  #   start: {Servy.PledgeServer, :start_link, [[]]}, type: :worker}
  # end

  # Client Interface

  def start_link(_arg) do
    IO.puts "Starting PledgeServer..."
    GenServer.start_link(__MODULE__, %State{}, name: @name)
  end

  def stop() do
    IO.puts "Stopping PledgeServer..."
    GenServer.stop(@name)
  end

  def create_pledge(name, amount) do
    GenServer.call @name, {:create_pledge, name, amount}
  end

  def recent_pledges do
    GenServer.call @name, :recent_pledges
  end

  def total_pledged do
    GenServer.call @name, :total_pledged
  end

  def clear do
    GenServer.cast @name, :clear
  end

  def set_cache_size(size) when is_integer(size) and size > 0 do
    GenServer.cast @name, {:set_cache_size, size}
  end

  # Server callbacks

  def init(state) do
    pledges = fetch_recent_pledges_from_service()
    new_state = %State{state | pledges: pledges}
    {:ok, new_state}
  end

  def handle_call({:create_pledge, name, amount}, _from, state) do
    {:ok, id} = send_pledge_to_service(name, amount)
    most_recent_pledges = Enum.take(state.pledges, state.cache_size - 1)
    cached_pledges = [{name, amount} | most_recent_pledges]
    new_state = %State{state | pledges: cached_pledges}
    {:reply, id, new_state}
  end

  def handle_call(:recent_pledges, _from, state) do
    {:reply, state.pledges, state}
  end

  def handle_call(:total_pledged, _from, state) do
    total = Enum.map(state.pledges, &elem(&1, 1)) |> Enum.sum()
    {:reply, total, state}
  end

  def handle_cast(:clear, state) do
    IO.puts "Clearing pledges..."
    {:noreply, %State{state | pledges: []}}
  end

  def handle_cast({:set_cache_size, size}, state) do
    resized_cache = Enum.take(state.pledges, size)
    new_state = %{state | cache_size: size, pledges: resized_cache}
    {:noreply, new_state}
  end

  def handle_info(message, state) do
    IO.puts "Ooops: #{inspect(message)}"
    {:noreply, state}
  end

  defp send_pledge_to_service(_name, _amount) do
    # Simulate sending the pledge to an external service
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end

  defp fetch_recent_pledges_from_service do
    # CODE GOES HERE TO FETCH RECENT PLEDGES FROM EXTERNAL SERVICE

    # Example return value:
    [ {"wilma", 15}, {"fred", 25} ]
  end
end

alias Servy.PledgeServer


{:ok, pid} = PledgeServer.start_link([])
IO.inspect Process.whereis(:pledge_server)
IO.inspect Process.registered() |> Enum.count()

PledgeServer.set_cache_size(5)

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
