defmodule Servy.BearController do

  alias Servy.Conv
  alias Servy.Wildthings
  alias Servy.Bear
  # alias Servy.BearView

  import Servy.View, only: [render: 3]

  def index(%Conv{} = conv) do
    items = Wildthings.list_bears()
    |> Enum.sort(&Bear.order_asc_by_name/2)

    render(conv, "index.eex", bears: items)
    # Using precompiled templates
    # %{ conv | status: 200, resp_body: BearView.index(items) }
  end

  def show(%Conv{} = conv, %{"id" => id}) do
    bear = Wildthings.get_bear(id)

    render(conv, "show.eex", bear: bear)
    # Using precompiled templates
    # %{ conv | status: 200, resp_body: BearView.show(bear) }
  end

  def create(%Conv{} = conv, %{"name" => name, "type" => type}) do
    %{ conv | status: 201, resp_body: "Created a #{type} bear named #{name}!" }
  end

  def delete(%Conv{} = conv, _params) do
    %{ conv | status: 403, resp_body: "Deleting a bear is forbidden!" }
  end
end
