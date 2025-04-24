defmodule Servy.Parser do
  @moduledoc """
  This module parses the request.
  """

  alias Servy.Conv

  def parse(request) do
    [top, params_string] = String.split(request, "\r\n\r\n", parts: 2)

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

  # Using recursion
  # defp parse_headers([head | tail], headers) do
  #   [key, value] = String.split(head, ": ")
  #   headers = Map.put(headers, key, value)
  #   parse_headers(tail, headers)
  # end

  # defp parse_headers([], headers), do: headers

  # Using Enum.reduce
  def parse_headers(header_lines) do
    Enum.reduce(header_lines, %{}, fn header_line, headers_acc ->
      [key, value] = String.split(header_line, ": ")
      Map.put(headers_acc, key, String.trim(value))
    end)
  end

  @doc """
  Parses the parameters from the request body based on the content type.

  ## Examples

      iex> json_string = ~s({"name": "Baloo", "type": "Brown"})
      iex> Servy.Parser.parse_params("application/json", json_string)
      %{"name" => "Baloo", "type" => "Brown"}

      iex> Servy.Parser.parse_params("application/x-www-form-urlencoded", "name=Baloo&type=Brown")
      %{"name" => "Baloo", "type" => "Brown"}
  """
  def parse_params("application/x-www-form-urlencoded", params_string) do
    params_string
    |> String.trim
    |> URI.decode_query
  end

  def parse_params("application/json", params_string) do
    params_string
    |> Poison.Parser.parse!(%{})
  end

  def parse_params(_, _), do: %{}
end
