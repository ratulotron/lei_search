defmodule LeiParser do
  @moduledoc "Parses the LEI CSV file and converts rows to maps."

  alias NimbleCSV.RFC4180, as: CSV

  def parse_csv(file_path) do
    # headers = extract_headers(file_path)

    # IO.inspect(headers)

    file_path
    |> File.stream!(read_ahead: 100_000)
    |> CSV.parse_stream(skip_headers: false)
    |> Stream.transform(nil, fn
      header, nil ->  # First iteration, return empty list and header
        {[], header}
      row, headers -> # Subsequent iterations, return list of maps and header
        {
          [Enum.zip(headers, row) |> Map.new()],
          headers
        }
     end)
    |> Stream.map(&transform_record/1)
    |> Enum.to_list()
  end

  def extract_headers(file_path) do
    file_path
    |> File.stream!()
    |> CSV.parse_stream(skip_headers: false)
    |> Enum.take(1)
    |> List.first()
  end

  defp transform_record(record) do
    %{
      lei: record["LEI"],
      entity: record["Entity"],
      legal_name: record["Legal Name"],
      country: record["Country"]
    }
  end
end
