alias Ecto.Adapters.SQL

alias Pghr.Item
alias Pghr.Repo

IO.puts("Deleting all existing items ...")

Repo.delete_all(Item)

seed_count = 5000

IO.puts("Creating #{seed_count} new items ...")

item_ids =
  Enum.map(1..seed_count, fn _ ->
    random = :rand.uniform(100_000_000_000_000)

    {:ok, %{id: id}} =
      Repo.insert(%Item{
        mumble1: "mumble",
        mumble2: "Mumble-#{random}",
        mumble3: "Moar Mumble #{random}"
      })

    id
  end)

IO.puts("Starting test ...")

ParallelBench.run(
  fn ->
    random_item_id = Enum.random(item_ids)
    random = :rand.uniform(100_000_000_000_000)

    {:ok, %{num_rows: 1}} =
      SQL.query(
        Repo,
        """
        UPDATE items
        SET mumble3 = $1
        WHERE id = $2;
        """,
        ["New Mumble #{random}", random_item_id]
      )
  end,
  parallel: 10,
  duration: 30
)
