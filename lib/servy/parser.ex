defmodule Servy.Parser do
  @moduledoc """
  This module parses the request.
  """

  alias Servy.Conv

  def parse(request) do
    [method, path, _] = request
      |> String.split("\n")
      |> List.first
      |> String.split(" ")

    %Conv{
      method: method,
      path: path
     }
  end
end
