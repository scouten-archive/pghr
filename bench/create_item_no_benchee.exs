alias Pghr.Item
alias Pghr.Repo

duration = 10
parallel = 10

IO.puts("Deleting all existing items ...")

Repo.delete_all(Item)

IO.puts("Starting test ...")

run_fn = fn(end_time, counter, run_fn) ->
  if System.monotonic_time(:millisecond) > end_time do
    IO.inspect counter, label: "counter"
    counter
  else
    random = :rand.uniform(100_000_000_000_000)

    {:ok, _} =
      Repo.insert(%Item{
        mumble1: "mumble",
        mumble2: "Mumble-#{random}",
        mumble3: "Moar Mumble #{random}"
      })

    run_fn.(end_time, counter + 1, run_fn)
  end
end

tasks =
  1..parallel
  |> Enum.map(fn _ ->
    Task.async(fn ->
      end_time = System.monotonic_time(:millisecond) + duration * 1000
      run_fn.(end_time, 0, run_fn)
    end)
  end)

total_count =
  tasks
  |> Enum.map(fn task -> Task.await(task, 5000 + duration * 1000) end)
  |> Enum.sum()

IO.inspect(total_count, label: "\n\ntotal number of transactions")
IO.inspect(total_count / duration, label: "transactions per second")
