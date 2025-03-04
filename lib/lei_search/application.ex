defmodule LeiSearch.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: LeiSearch.Worker.start_link(arg)
      # {LeiSearch.Worker, arg}
      Fetch.Latest,
      LeiSearch
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LeiSearch.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
