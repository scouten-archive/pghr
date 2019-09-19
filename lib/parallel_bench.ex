defmodule ParallelBench do
  def run(run_fn, opts) do
    parallel = Keyword.get(opts, :parallel, 1)
    duration = Keyword.get(opts, :duration, 10)

    IO.puts "Running #{parallel} processes for #{duration} seconds"

    iteration_count =
      1..parallel
      |> Enum.map(fn _ ->
        Task.async(fn ->
          end_time = System.monotonic_time(:millisecond) + duration * 1000
          iterate(run_fn, 0, end_time)
        end)
      end)
      |> Enum.map(fn task ->
        Task.await(task, 5000 + duration * 1000)
      end)
      |> Enum.sum()

    IO.inspect(iteration_count, label: "\n\ntotal number of iterations")
    IO.inspect(iteration_count / duration, label: "iterations per second")
  end

  defp iterate(run_fn, counter, end_time) do
    if System.monotonic_time(:millisecond) > end_time do
      counter
    else
      run_fn.()
      iterate(run_fn, counter + 1, end_time)
    end
  end
end
