# Pghr

Quick 'n' dirty test to see how Ecto + Postgres behave in specific microbenchmarks.

## Test Methodology

The benchmark results described below were run on my 2015-era MacBook Pro. Tests were always run for 10 seconds with a 2-second warm-up. Varying levels of parallelism were used and noted in the test results.

```
$ mix run bench/create_item_fast.exs 
Deleting all existing items ...
Starting test ...
Operating System: macOS
CPU Information: Intel(R) Core(TM) i7-4980HQ CPU @ 2.80GHz
Number of Available Cores: 8
Available memory: 16 GB
Elixir 1.9.1
Erlang 22.0.7

Benchmark suite executing with the following configuration:
warmup: 2 s
time: 10 s
memory time: 0 ns
parallel: 5
inputs: none specified
Estimated total run time: 12 s

Benchmarking create item...

Name                  ips        average  deviation         median         99th %
create item        1.36 K      734.57 μs   ±702.99%         422 μs         635 μs
```

## Results

### Create Item Benchmark

See `bench/create_item_fast.exs`.
   ips |   average | deviation | parallel | What Changed? (PR #)
------:|----------:|----------:|---------:|:---
  1360 | 734.57 μs |  ±702.99% | 5 | **Initial benchmark** (#1)
  1260 | 790.86 μs |  ±680.23% | 10 | – Same with 10 "bots"
   942 |   1.06 ms |   ±96.84% | 20 | – Same with 20 "bots"
