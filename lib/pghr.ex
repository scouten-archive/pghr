defmodule Pghr do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Pghr.Repo, []}
    ]

    opts = [strategy: :one_for_one, name: Pghr.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
