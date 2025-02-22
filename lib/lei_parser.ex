defmodule LeiParser do
  @moduledoc "Parses the LEI CSV file and converts rows to maps."

  alias NimbleCSV.RFC4180, as: CSV

  def parse_csv(file_path, limit \\ 100) do
    file_path
    |> File.stream!()
    |> CSV.parse_stream()
    |> Stream.transform(nil, fn
      # Extract headers from the first row
      row, nil -> {[], row}
      # Convert each subsequent row into a map
      row, headers -> {[Enum.zip(headers, row) |> Map.new()], headers}
    end)
    |> Stream.take(limit)
    |> Enum.to_list()
  end
end
