# I used this because there was a problem with `psql` on my machine.
# Rather than reinstall Postgres and invalidate existing results,
# I chose to seed the database using this Elixir process instead.
# This is the seed half of the corresponding Elixir test.

alias Pghr.Item
alias Pghr.Repo

seed_count = 5000

IO.puts("Creating #{seed_count} new items ...")

_item_ids =
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
