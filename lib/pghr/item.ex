defmodule Pghr.Item do
  use Ecto.Schema

  schema "items" do
    field(:mumble1, :string)
    field(:mumble2, :string)
    field(:mumble3, :string)
  end
end
