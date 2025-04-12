defmodule Exercises.Capture do
  add = fn(a,b) -> a + b end
  IO.puts add.(1, 2)

  add = &(&1 + &2)
  IO.puts add.(3, 5)

  repeat = &String.duplicate(&1, &2)
  IO.puts repeat.("hello", 3)

  repeat = &String.duplicate/2
  IO.puts repeat.("bye", 3)

  def my_map(list, func), do: my_map(list, func, [])

  defp my_map([head|tail], func, current_list) do
    my_map(tail, func, [func.(head) | current_list])
  end

  defp my_map([], _func, current_list) do
    current_list |> Enum.reverse()
  end
end


nums = [1, 2, 3, 4, 5]
IO.inspect Exercises.Capture.my_map(nums, &(&1 * 2))
IO.inspect Exercises.Capture.my_map(nums, &(&1 * &1))
