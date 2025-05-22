# Unused code
# Was an example of how Task.async and Task.await works
defmodule Servy.Fetcher do

  def async(fun) do
    parent = self()

    spawn(fn -> send(parent, {self(), :result, fun.()}) end)
  end

  def get_result(pid) do
    receive do
      # We use the pin operator (^) to match only messages from the specific spawned process (pid),
      # ensuring we don't accidentally receive messages from other processes.
      {^pid, :result, value} -> value
    end
  end
end
