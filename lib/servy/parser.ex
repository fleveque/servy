defmodule Servy.Parser do
  @moduledoc """
  This module parses the request.
  """

  alias Servy.Conv

  def parse(request) do
    [top, params_string] = String.split(request, "\n\n", parts: 2)

    [request_line | header_lines] = String.split(top, "\n")

    [method, path, _] = String.split(request_line, " ")

    headers = parse_headers(header_lines)

    params = parse_params(headers["Content-Type"], params_string)

    %Conv{
      method: method,
      path: path,
      headers: headers,
      params: params
     }
  end

  # defp parse_headers([head | tail], headers) do
  #   [key, value] = String.split(head, ": ")
  #   headers = Map.put(headers, key, value)
  #   parse_headers(tail, headers)
  # end

  # defp parse_headers([], headers), do: headers

  defp parse_headers(header_lines) do
    Enum.reduce(header_lines, %{}, fn header_line, headers_acc ->
      [key, value] = String.split(header_line, ": ")
      Map.put(headers_acc, key, value)
    end)
  end

  defp parse_params("application/x-www-form-urlencoded", params_string) do
    params_string
    |> String.trim
    |> URI.decode_query
  end

  defp parse_params(_, _), do: %{}
end
