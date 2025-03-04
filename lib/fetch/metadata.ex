defmodule Fetch.Metadata do
  @moduledoc """
  Fetches the latest metadata about the LEI data, such as the URL to the latest LEI data.
  """

  alias HTTPoison
  alias Jason

  @gleif_meta "https://leidata-preview.gleif.org/api/v2/golden-copies/publishes"

  def get_latest_metadata do
    case HTTPoison.get(@gleif_meta) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> {:ok, body}
      {:error, reason} -> {:error, "Failed to download LEI metada: #{inspect(reason)}"}
    end
  end

  defp decode(body, type) do
    case Jason.decode(body) do
      {:ok, %{"data" => [latest_entry | _]}} ->
        case get_in(latest_entry, ["lei2", "full_file", type, "url"]) do
          nil -> {:error, "JSON URL not found"}
          url -> {:ok, url}
        end
      {:error, decode_error} ->
        {:error, "Failed to decode JSON: #{inspect(decode_error)}"}
    end
  end

  def fetch_url(type) do
    case get_latest_metadata() do
      {:ok, body} -> decode(body, type)
      {:error, reason} -> {:error, reason}
    end
  end
end
