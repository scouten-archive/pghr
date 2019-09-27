alias Ecto.Adapters.SQL

alias Pghr.Item
alias Pghr.Repo

IO.puts("Deleting all existing items ...")

Repo.delete_all(Item)

ParallelBench.run(
  fn ->
    random = :erlang.unique_integer([:positive])

    {:ok, _} =
      Repo.insert(%Item{
        mumble1: "mumble",
        mumble2: "Mumble-#{random}",
        mumble3: "Moar Mumble #{random}"
      })
  end,
  truncate?: true,
  parallel: 40,
  duration: 30
)

IO.inspect(SQL.query!(Repo, "SELECT count(*) FROM items;"),
  label: "\n\nCount of records now in DB"
)
