
defmodule Exercises.Recurse do

  def sum(list), do: sum(list, 0)

  def sum([head | tail], total) do
    IO.puts "Total: #{total} Head: #{head} Tail: #{inspect(tail)}"
    sum(tail, total + head)
  end

  def sum([], total), do: total

  def triple(list), do: triple(list, [])

  defp triple([head|tail], current_list) do
    triple(tail, [head*3 | current_list])
  end

  defp triple([], current_list) do
    current_list |> Enum.reverse()
  end

end

IO.puts Exercises.Recurse.sum([1, 2, 3, 4, 5])

IO.inspect Exercises.Recurse.triple([1, 2, 3, 4, 5])
