alias Pghr.Item
alias Pghr.Repo

import Ecto.Query

IO.puts("Deleting all existing items ...")

Repo.delete_all(Item)

IO.puts("Creating 5,000 new items ...")

item_ids =
  Enum.map(1..5000, fn _ ->
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

    {1, _} =
      from(i in Item, where: i.id == ^random_item_id)
      |> Repo.update_all(set: [mumble3: "New Mumble #{random}"])
  end,
  parallel: 10,
  duration: 10
)
