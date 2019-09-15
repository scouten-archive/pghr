alias Pghr.Item
alias Pghr.Repo

IO.puts("Deleting all existing items ...")

Repo.delete_all(Item)

IO.puts("Starting test ...")

Benchee.run(
  %{
    "create item" => fn ->
      random = :rand.uniform(100_000_000_000_000)

      {:ok, _} =
        Repo.insert(%Item{
          mumble1: "mumble",
          mumble2: "Mumble-#{random}",
          mumble3: "Moar Mumble #{random}"
        })
    end
  },
  parallel: 5,
  time: 10
)
