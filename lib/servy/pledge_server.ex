defmodule Servy.PledgeServer do
  def create_pledge(name, amount) do
    {:ok, id} = send_pledge_to_service(name, amount)

    IO.puts("Pledge created with ID: #{id}")
  end

  defp send_pledge_to_service(_name, _amount) do
    # Simulate sending the pledge to an external service
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end

  def recent_pledges do
    [
      %{name: "Alice", amount: 100},
      %{name: "Bob", amount: 200}
    ]
  end
end
