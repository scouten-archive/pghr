alias Pghr.Item
alias Pghr.Repo

IO.puts("Deleting all existing items ...")

Repo.delete_all(Item)

ParallelBench.run(fn ->
  random = :rand.uniform(100_000_000_000_000)

  {:ok, _} =
    Repo.insert(%Item{
      mumble1: "mumble",
      mumble2: "Mumble-#{random}",
      mumble3: "Moar Mumble #{random}"

      })
end, parallel: 10, duration: 10)
