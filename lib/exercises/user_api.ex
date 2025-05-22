defmodule UserAPI do
  def query(user_id) do
    url = "https://jsonplaceholder.typicode.com/users/#{user_id}"
    headers = [{"Content-Type", "application/json"}]

    case HTTPoison.get(url, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        city = Poison.Parser.parse!(body, %{}) |>
               get_in(["address", "city"])
        {:ok, city}

      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        {:error, "Error: #{status_code}"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, "Error: #{reason}"}
    end
  end

  def run do
    case query("1") do
      {:ok, city} ->
        city
      {:error, error} ->
        "Whoops! #{error}"
    end
  end
end
