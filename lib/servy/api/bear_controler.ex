defmodule Servy.Api.BearController do
  alias Servy.Conv

  def index(%Conv{} = conv) do
    json = Servy.Wildthings.list_bears()
    |> Poison.encode!

    %{conv | status: 200, resp_content_type: "application/json", resp_body: json}
  end
end
