alias Pghr.Item
alias Pghr.Repo

import Ecto.Query

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

IO.puts("Starting test ...")

ParallelBench.run(
  fn ->
    random_item_id = :rand.uniform(seed_count - 1) + first_item_id
    random = :rand.uniform(100_000_000_000_000)

    {1, _} =
      from(i in Item, where: i.id == ^random_item_id)
      |> Repo.update_all(set: [mumble3: "New Mumble #{random}"])
  end,
  parallel: 10,
  duration: 30
)
