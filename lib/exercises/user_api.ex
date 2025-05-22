defmodule UserAPI do
  def query(id) do
    api_url(id)
    |> HTTPoison.get(headers())
    |> handle_response
  end

  defp api_url(id) do
    "https://jsonplaceholder.typicode.com/users/#{URI.encode(id)}"
  end

  defp headers do
    [{"Content-Type", "application/json"}]
  end

  defp handle_response({:ok, %HTTPoison.Response{status_code: 200, body: body}}) do
    city = Poison.Parser.parse!(body, %{})
           |> get_in(["address", "city"])
    {:ok, city}
  end
  defp handle_response({:ok, %HTTPoison.Response{status_code: status_code}}) do
    {:error, "Error: #{status_code}"}
  end
  defp handle_response({:error, %HTTPoison.Error{reason: reason}}) do
    {:error, "Error: #{reason}"}
  end

  def run(id) do
    case query(id) do
      {:ok, city} ->
        city
      {:error, error} ->
        "Whoops! #{error}"
    end
  end
end
