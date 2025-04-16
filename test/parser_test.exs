defmodule ParserTest do
  use ExUnit.Case
  doctest Servy.Parser

  alias Servy.Parser

  test "parses a list of header fields into a map" do
    headers = [
      "Host: localhost:4000",
      "User-Agent: curl/7.64.1",
      "Accept: */*"
    ]

    expected = %{
      "Host" => "localhost:4000",
      "User-Agent" => "curl/7.64.1",
      "Accept" => "*/*"
    }

    assert Parser.parse_headers(headers) == expected
  end
end
