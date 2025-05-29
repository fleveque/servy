defmodule Servy.ServicesSupervisor do
  use Supervisor

  def start_link(_arg) do
    IO.puts "Starting Services Supervisor..."
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      Servy.PledgeServer,
      {Servy.SensorServer, 60},
      # You can also use  a list of keywords:
      # {Servy.SensorServer, interval: 60, target: "bigfoot"}
      # and use Keyword.get(options, :interval) on SensorServer.start_link
      # or a map:
      # %{
      #   id: Servy.SensorServer,
      #   start: {Servy.SensorServer, :start_link, [60]}
      # }
      # or using pattern matching on SensorServer.child_spec:
      # {Servy.SensorServer, :frequent}
      Servy.FourOhFourCounter
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
