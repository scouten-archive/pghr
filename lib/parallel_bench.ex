defmodule ParallelBench do
  def run(run_fn, opts) do
    parallel = Keyword.get(opts, :parallel, 1)
    duration = Keyword.get(opts, :duration, 10)
    profile? = Keyword.get(opts, :profile?, false)
    truncate? = Keyword.get(opts, :truncate?, false)

    IO.puts("Running #{parallel} processes for #{duration} seconds")

    IO.puts("Warming up")

    Enum.each(1..1000, fn _ ->
      run_fn.()
    end)

    if truncate? do
      Pghr.Repo.query!("TRUNCATE TABLE items", [])
    end

    IO.puts("Benchmarking")

    if profile? do
      IO.puts("Capturing profiling data")
      :fprof.trace([:start, verbose: true, procs: :all])
    end

    iteration_count =
      1..parallel
      |> Enum.map(fn _ ->
        Task.async(fn ->
          end_time = System.monotonic_time(:millisecond) + duration * 1000
          checkout_and_iterate(run_fn, 0, end_time)
        end)
      end)
      |> Enum.map(fn task ->
        Task.await(task, 5000 + duration * 1000)
      end)
      |> Enum.sum()

    if profile? do
      :fprof.trace(:stop)
      :fprof.profile()
      :fprof.analyse(totals: false, dest: '/Users/scouten/Desktop/prof.analysis')
    end

    IO.inspect(iteration_count, label: "\n\ntotal number of iterations")
    IO.inspect(iteration_count / duration, label: "iterations per second")
  end

  defp checkout_and_iterate(run_fn, counter, end_time) do
    # HACKY! I *did* say this was a quick-n-dirty tool, right?
    # This is the part where we break the benchmarking-tool abstraction
    # and shamelessly optimize for Repo-specific things.

    if System.monotonic_time(:millisecond) > end_time do
      counter
    else
      counter =
        Pghr.Repo.checkout(fn ->
          iterate(run_fn, counter + 1, 500, end_time)
        end)

      checkout_and_iterate(run_fn, counter, end_time)
    end
  end

  defp iterate(_run_fn, counter, 0 = _iterations_in_checkout, _end_time) do
    counter
  end

  defp iterate(run_fn, counter, iterations_in_checkout, end_time) do
    if System.monotonic_time(:millisecond) > end_time do
      counter
    else
      run_fn.()
      iterate(run_fn, counter + 1, iterations_in_checkout - 1, end_time)
    end
  end
end
