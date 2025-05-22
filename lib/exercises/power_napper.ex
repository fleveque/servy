defmodule PowerNapper do
  def run do
    power_nap = fn ->
      time = :rand.uniform(10_000)
      :timer.sleep(time)
      time
    end

    parent = self()
    spawn(fn ->
      result = power_nap.()
      send(parent, {:result, result})
    end)

    receive do
      {:result, time} ->
        IO.puts("Slept for #{time} milliseconds")
    end
  end
end
