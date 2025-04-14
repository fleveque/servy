defmodule Exercises.Comprehensions do
  prefs = [ {"Betty", :dog}, {"Bob", :dog}, {"Becky", :cat} ]

  IO.inspect for {name, :dog} <- prefs, do: name

  IO.inspect for {name, pet_choice} <- prefs, pet_choice == :dog, do: name

  dog_lover? = fn(choice) -> choice == :dog end
  cat_lover? = fn(choice) -> choice == :cat end

  IO.inspect for {name, pet_choice} <- prefs, dog_lover?.(pet_choice), do: name
  IO.inspect for {name, pet_choice} <- prefs, cat_lover?.(pet_choice), do: name

  style = %{"width" => 10, "height" => 20, "border" => "2px"}
  IO.inspect for {key, val} <- style, into: %{}, do: {String.to_atom(key), val}

  ranks = [ "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A" ]
  suits = [ "♣", "♦", "♥", "♠" ]

  deck = for rank <- ranks, suit <- suits, do: { rank, suit }
  IO.inspect deck

  deck
  |> Enum.shuffle
  |> Enum.take(13)
  |> IO.inspect

  deck
  |> Enum.shuffle
  |> Enum.chunk_every(13)
  |> IO.inspect
end
