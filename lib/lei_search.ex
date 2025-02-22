defmodule LeiSearch do
  @moduledoc """
  Module for fetching and processing LEI (Legal Entity Identifier) data.

  This module interacts with the GLEIF API to retrieve the latest LEI golden copy files.
  It provides functions for fetching the latest LEI CSV URL, decoding the metadata,
  and fetching the data itself.
  """
  def fetch_data do
    with {:ok, url} <- LatestMetadata.fetch_url("csv"),
         {:ok, path} <- LeiDownloader.fetch(url) do
      {:ok, "LEI data fetched and parsed successfully to #{path}"}
    end
  end

  def hello do
    "Hello, world!"
  end

  def start(_type, _args) do
    LeiSearch.fetch_data()
    Supervisor.start_link([], strategy: :one_for_one)
  end
end
