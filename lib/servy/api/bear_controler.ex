defmodule Servy.Api.BearController do
  alias Servy.Conv

  def index(%Conv{} = conv) do
    json = Servy.Wildthings.list_bears()
    |> Poison.encode!

    conv = put_resp_content_type(conv, "application/json")

    %{ conv | status: 200, resp_body: json }
  end

  def create(%Conv{} = conv, %{"name" => name, "type" => type}) do
    %{ conv | status: 201, resp_body: "Created a #{type} bear named #{name}!" }
  end

  defp put_resp_content_type(%Conv{} = conv, content_type) do
    new_headers = Map.put(conv.resp_headers, "Content-Type", content_type)
    %{conv | resp_headers: new_headers}
  end
end
