defmodule Servy.KickStarter do

  use GenServer

  def start_link(_arg) do
    IO.puts "Starting Servy KickStarter..."
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def get_server do
    GenServer.call __MODULE__, :get_server
  end

  # Server Callbacks

  def init(:ok) do
    Process.flag(:trap_exit, true)
    server_pid = start_server()
    {:ok, server_pid}
  end

  def handle_call(:get_server, _from, state) do
    {:reply, state, state}
  end

  def handle_info({:EXIT, _pid, reason}, _state) do
    IO.puts "HTTP server exited with reason: #{inspect(reason)}"
    server_pid = start_server()
    {:noreply, server_pid}
  end

  defp start_server do
    IO.puts "Starting the HTTP server..."
    if Process.whereis(:http_server) do
      Process.unregister(:http_server)
    end
    port = Application.get_env(:servy, :http_port, 4000)
    pid = spawn_link(Servy.HttpServer, :start, [port])
    Process.register(pid, :http_server)
  end
end
