# Pghr

Quick 'n' dirty test to see how Ecto + Postgres behave in specific microbenchmarks.

## Test Methodology

The benchmark results described below were run on my 2015-era MacBook Pro. Tests were always run for 10 seconds with a 2-second warm-up. Varying levels of parallelism were used and noted in the test results.

### For Ecto + Benchee

```
$ mix ecto.drop && mix ecto.create && mix ecto.migrate && mix run bench/create_item_fast.exs 
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

### For pgbench

```
$ mix ecto.drop && mix ecto.create && mix ecto.migrate && pgbench -f pgbench/create_item_fast.sql -n -c 10 -j 5 -T 10 pghr
transaction type: pgbench/create_item_fast.sql
scaling factor: 1
query mode: simple
number of clients: 10
number of threads: 5
duration: 10 s
number of transactions actually processed: 206051
latency average = 0.487 ms
tps = 20515.651758 (including connections establishing)
tps = 20523.650252 (excluding connections establishing)
```

## Results

### Create Item Benchmark

See `bench/create_item_fast.exs` or `pgbench/create_item_fast.sql`.

   ips |   average | deviation | parallel | pool_size | What Changed? (PR #)
------:|----------:|----------:|---------:|----------:|:---
  1360 | 734.57 μs |  ±702.99% |        5 |        10 | **Initial benchmark** (#1)
  1260 | 790.86 μs |  ±680.23% |       10 |        10 |
   942 |   1.06 ms |   ±96.84% |       20 |        10 |
  2200 | 454.16 μs |  ±115.65% |        5 |        20 |
  2400 | 415.93 μs |   ±14.41% |        5 |        40 |
  2120 | 470.70 μs |  ±194.43% |        5 |        50 |
  1780 | 560.66 μs |   ±37.77% |       10 |        40 |
   890 |   1.12 ms |  ±266.23% |       20 |        40 |
 20515 |    487 µs |           |        5 |        10 | **Initial `pgbench` test** (#3)
 21376 |    468 µs |           |       10 |        10 |
 21550 |    464 µs |           |       20 |        10 |
 28652 |    698 µs |           |        5 |        20 |
 28537 |   1.40 ms |           |        5 |        40 |
 28152 |   1.78 ms |           |        5 |        50 |
 27950 |   1.43 ms |           |       10 |        40 |
 28297 |   1.41 ms |           |       20 |        40 |

### Update Item Benchmark

See `bench/update_item_fast.exs`.

For `pgbench`, the command was:

```
mix ecto.drop && mix ecto.create && mix ecto.migrate && mix run pgbench/seed_items.exs && pgbench -f pgbench/update_item_fast.sql -n -c 10 -j 5 -T 10 pghr
```

   ips |   average | deviation | parallel | pool_size | What Changed? (PR #)
------:|----------:|----------:|---------:|----------:|:---
   296 |   3.37 ms |   ±34.19% |        5 |        10 | **Initial benchmark** (#2)
 21694 |    461 µs |           |        5 |        10 | **Initial `pgbench` test** (#4)   
 20673 |    484 µs |           |       10 |        10 |
 21199 |    472 µs |           |       20 |        10 |
 28062 |    713 µs |           |        5 |        20 |
 29292 |   1.37 ms |           |        5 |        40 |
   292 |   3.42 ms |   ±34.21% |        5 |        10 | **Rewrite query using Ecto** (#5)
   164 |   6.09 ms |   ±39.47% |       10 |        10 |
    84 |  11.90 ms |   ±30.74% |       20 |        10 |
   275 |   3.63 ms |   ±46.30% |        5 |        20 |
   