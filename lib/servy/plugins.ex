defmodule Servy.Plugins do
  @moduledoc """
  This module contains the plugins for Servy.
  """

  require Logger

  alias Servy.Conv

  def rewrite_path(%Conv{path: "/wildlife"} = conv) do
    %{ conv | path: "/wildthings" }
  end

  def rewrite_path(%Conv{path: path} = conv) do
    regex = ~r{\/(?<thing>\w+)\?id=(?<id>\d+)}
    captures = Regex.named_captures(regex, path)
    rewrite_path_captures(conv, captures)
  end

  defp rewrite_path_captures(%Conv{} = conv, %{"thing" => thing, "id" => id}) do
    %{ conv | path: "/#{thing}/#{id}" }
  end

  defp rewrite_path_captures(%Conv{} = conv, nil), do: conv

  def log(%Conv{} = conv), do: IO.inspect conv

  @doc "Logs 404 requests"
  def track(%Conv{status: 404, path: path} = conv) do
    Logger.warning "Warning: #{path} was not found"
    conv
  end

  def track(%Conv{} = conv), do: conv

  def emojify(%Conv{status: 200} = conv) do
    emojies = String.duplicate("🎉", 5)
    %{ conv | resp_body: emojies <> "\n" <> conv.resp_body  <> "\n" <> emojies }
  end

  def emojify(%Conv{} = conv), do: conv
end
