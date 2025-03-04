defmodule LeiSearch do
  @moduledoc """
  Module for fetching and processing LEI (Legal Entity Identifier) data.

  This module interacts with the GLEIF API to retrieve the latest LEI golden copy files.
  It provides functions for fetching the latest LEI CSV URL, decoding the metadata,
  and fetching the data itself.
  """

  alias Fetch.Latest, as: Latest
  alias Fetch.Metadata, as: Meta

  require Logger

  use GenServer

  @impl true
  def init(init_arg) do
    {:ok, init_arg}
  end

  def start_link(_opts) do
    GenServer.start_link(
      __MODULE__,
      %{
        "last_download_url" => nil,
        "last_downloaded_at" => 0
      },
      name: __MODULE__
    )
  end

  @impl true
  def handle_call(
        :fetch,
        _from,
        %{
          "last_download_url" => last_download_url,
        } = state
      ) do
    now = :os.system_time(:millisecond)
    # Get the latest URL if it has been more than 30 seconds since the last download

    {:ok, url} = Meta.fetch_url("csv")

    Logger.info("Last download url: #{url}")

    if url != last_download_url do
      case Latest.fetch(url) do
        {:ok, path} ->
          {:reply, "Data fetched and parsed successfully to #{path}",
           %{
             "last_download_url" => url,
             "last_downloaded_at" => now
           }}

        {:error, reason} ->
          {:reply, reason, state}
      end
    else
      {:reply, "Data already fetched", state}
    end
  end

  def get(), do: GenServer.call(__MODULE__, :fetch)
end
