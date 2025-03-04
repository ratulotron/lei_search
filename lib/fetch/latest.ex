defmodule Fetch.Latest do
  @moduledoc """
  Module for downloading JSON data from a URL.
  """

  require Logger

  alias HTTPoison
  alias Jason

  alias Fetch.Metadata, as: URL

  use GenServer

  @data_dir "data"

  defp get_file_path(url) do
    Path.join(@data_dir, Path.basename(url))
  end

  def file_exists?(url) do
    file_path = get_file_path(url)

    if File.exists?(file_path) do
      Logger.info("File already exists: #{file_path}, skipping download")
      {:ok, file_path}
    else
      {:error, file_path}
    end
  end

  defp download(url, file_path) do
    Logger.info("Downloading JSON data from #{url} to #{file_path}")

    case HTTPoison.get(url, [], recv_timeout: 300_000) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        File.write!(file_path, body)
        Logger.info("Downloaded JSON data to #{file_path}")
        {:ok, file_path}

      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        {:error, "Failed to download JSON: Received HTTP #{status_code}"}

      {:error, reason} ->
        {:error, "Failed to download JSON: #{inspect(reason)}"}
    end
  end

  defp extract(path) do
    options = [:verbose, {:cwd, to_charlist(@data_dir)}]
    Logger.info("Extracting ZIP data from #{path}")

    case :zip.extract(to_charlist(path), options) do
      {:ok, extracted_files} ->
        extracted_file = List.first(extracted_files) |> to_string()
        Logger.info("Extraction completed. Data file: #{extracted_file}")
        {:ok, Path.join(@data_dir, extracted_file)}

      {:error, reason} ->
        {:error, "Failed to extract ZIP: #{inspect(reason)}"}
    end
  end

  def fetch(url) do
    File.mkdir_p!(@data_dir)

    case file_exists?(url) do
      {:ok, file_path} ->
        extract(file_path)

      {:error, file_path} ->
        with {:ok, file_path} <- download(url, file_path),
             {:ok, _} <- extract(file_path) do
          {:ok, file_path}
        else
          {:error, reason} -> {:error, reason}
        end
    end
  end

  # Client
  def start_link(_args) do
    GenServer.start_link(
      __MODULE__,
      %{
        "last_download_url" => nil,
        "last_download_path" => nil
      },
      name: __MODULE__
      )
  end

  # Server
  @impl true
  def init(init_args) do
    {:ok, init_args}
  end

  @impl true
  def handle_call(
        :fetch,
        _from,
        %{
          "last_download_url" => last_download_url,
          # "last_download_path" => last_download_path
        } = state
      ) do
    # Get the URL for the latest LEI data
    with {:ok, new_download_url} <- URL.fetch_url("csv") do
      if new_download_url == last_download_url do
        {:reply, {:ok, "Today's data was already fetched."}, state}
      else
        case fetch(new_download_url) do
          {:ok, last_download_path} ->
            Logger.info("Data fetched and parsed successfully to #{last_download_path}")
            {:reply, {:ok, last_download_path},
             %{
               "last_download_url" => last_download_url,
               "last_download_path" => last_download_path
             }}

          {:error, reason} ->
            {:reply, {:error, reason}, state}
        end
      end
    end
  end

  def get(), do: GenServer.call(__MODULE__, :fetch)
end
