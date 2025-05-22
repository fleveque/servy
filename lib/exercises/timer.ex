defmodule Exercises.Timer do
  def remind(message, seconds) do
    spawn(fn ->
      :timer.sleep(seconds * 1000)
      IO.puts(message)
    end)
  end
end

# Timer.remind("Hello!", 5)
# Timer.remind("Goodbye!", 10)

# :timer.sleep(:infinity)
