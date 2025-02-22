defmodule LeiSearch.MixProject do
  use Mix.Project

  def project do
    [
      app: :lei_search,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {LeiSearch, []}, # This is the module that starts the application, and the empty list is the argument to the start/2 function in that module
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.8"},
      # For parallel processing
      {:flow, "~> 1.2"},
      # For database interaction
      {:ecto_sql, "~> 3.12"},
      # PostgreSQL adapter
      {:postgrex, "~> 0.20"},
      # For search (or replace with :elasticsearch)
      {:meilisearch, "~> 0.20.0"},
      {:bolt_sips, "~> 2.0"},
      # JSON parsing
      {:jason, "~> 1.4"},
      {:nimble_csv, "~> 1.1"}
    ]
  end
end
