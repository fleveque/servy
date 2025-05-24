defmodule Servy.PledgeServer do

  def listen_loop(state) do
    IO.puts "Listening for pledge requests..."

    receive do
      {:create_pledge, name, amount} ->
        {:ok, id} = send_pledge_to_service(name, amount)
        new_state = [ {name, amount} | state ]
        IO.puts "#{name} pledged #{amount} with ID: #{id}"
        IO.puts "New state: #{inspect new_state}"
        listen_loop(new_state)

      {sender, :recent_pledges} ->
        send(sender, {:response, state})
        IO.puts "Sent pledges to #{inspect sender}"
        listen_loop(state)

      _ ->
        listen_loop(state)
    end
  end

  # def create_pledge(name, amount) do
  #   {:ok, id} = send_pledge_to_service(name, amount)

  #   IO.puts("Pledge created with ID: #{id}")
  # end

  # def recent_pledges do
  #   [
  #     %{name: "Alice", amount: 100},
  #     %{name: "Bob", amount: 200}
  #   ]
  # end

  defp send_pledge_to_service(_name, _amount) do
    # Simulate sending the pledge to an external service
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end
end
