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

first_item_id = List.first(item_ids)
last_item_id = first_item_id + seed_count - 1
^last_item_id = List.last(item_ids)

mumble_count = 100

new_mumbles =
  1..mumble_count
  |> Enum.map(fn i -> {i, "New Mumble #{i}"} end)
  |> Map.new()

IO.puts("Starting test ...")

ParallelBench.run(
  fn ->
    random_item_id =
      first_item_id + Integer.mod(:erlang.unique_integer([:positive]), seed_count - 1)

    random_mumble =
      Map.get(new_mumbles, 1 + Integer.mod(:erlang.unique_integer([:positive]), mumble_count - 1))

    {:ok, %{num_rows: 1}} =
      SQL.query(
        Repo,
        """
        UPDATE items
        SET mumble3 = $1
        WHERE id = $2;
        """,
        [random_mumble, random_item_id],
        cache_statement: "update_item_mumble"
      )
  end,
  truncate?: false,
  parallel: 40,
  duration: 30
)
