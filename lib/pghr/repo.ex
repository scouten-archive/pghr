defmodule Pghr.Repo do
  use Ecto.Repo,
    otp_app: :pghr,
    adapter: Ecto.Adapters.Postgres
end
