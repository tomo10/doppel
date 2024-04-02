defmodule Doppel.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Doppel.Results,
      {Doppel.PathFinder, "."},
      Doppel.WorkerSupervisor
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_all, name: Doppel.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
