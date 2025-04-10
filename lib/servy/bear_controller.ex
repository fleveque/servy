defmodule Servy.BearController do

  alias Servy.Conv
  alias Servy.Wildthings
  alias Servy.Bear

  def index(%Conv{} = conv) do
    items = Wildthings.list_bears()
    |> Enum.filter(&Bear.is_grizzly(&1))
    |> Enum.sort(&Bear.order_asc_by_name(&1, &2))
    |> Enum.map(&bear_item(&1))
    |> Enum.join()

    %{ conv | status: 200, resp_body: "<ul>#{items}</ul>" }
  end

  def show(%Conv{} = conv, %{"id" => id}) do
    bear = Wildthings.get_bear(id)

    %{ conv | status: 200, resp_body: "<h1>Bear #{bear.id}: #{bear.name}</h1>" }
  end

  def create(%Conv{} = conv, %{"name" => name, "type" => type} = params) do
    %{ conv | status: 201, resp_body: "Created a #{type} bear named #{name}!" }
  end

  defp bear_item(%{id: id, name: name}) do
    "<li>Bear #{id}: #{name}</li>"
  end
end
