defmodule PledgeServerTest do
  use ExUnit.Case

  alias Servy.PledgeServer

  setup do
    PledgeServer.start()
    PledgeServer.clear()
    :ok
  end

  test "getting recent pledges" do
    PledgeServer.create_pledge("Bob", 50)
    PledgeServer.create_pledge("Charlie", 75)

    assert PledgeServer.recent_pledges() == [{"Charlie", 75}, {"Bob", 50}]
  end

  test "It only caches 3 most recent pledges" do
    PledgeServer.create_pledge("Alice", 100)
    PledgeServer.create_pledge("Bob", 50)
    PledgeServer.create_pledge("Charlie", 75)
    PledgeServer.create_pledge("Dave", 200)

    assert PledgeServer.recent_pledges() == [{"Dave", 200}, {"Charlie", 75}, {"Bob", 50}]
  end

  test "calculating total pledged amount" do
    PledgeServer.create_pledge("Alice", 100)
    PledgeServer.create_pledge("Bob", 50)

    assert PledgeServer.total_pledged() == 150
  end
end
