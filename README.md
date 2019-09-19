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

**NOTE:** As of PR #6, I've removed previous benchmarks and re-run the corresponding `pgbench` results. This is because:

* Feedback from the community suggested that this use of `benchee` was outside of its intended design space.
* I upgraded Postgres from 9.6 to 11.5 on my machine. The `pgbench` results remained similar in the new tests.

### Create Item Benchmark

See `bench/create_item_fast.exs` or `pgbench/create_item_fast.sql`.

   ips | parallel | pool_size | What Changed? (PR #)
------:|---------:|----------:|:---
 22311 |        5 |        10 | **Initial `pgbench` test** (#3)
 21895 |       10 |        10 |
 23515 |       20 |        10 |
 28983 |        5 |        20 |
 27452 |        5 |        40 |
 28164 |        5 |        50 |
 28053 |       10 |        40 |
 25328 |       20 |        40 |
 12048 |        5 |        10 | **Remove benchee from process** (#6)
 16185 |       10 |        10 |
 17210 |       20 |        10 |
 11742 |        5 |        20 |
 11964 |        5 |        40 |
 16706 |       10 |        40 |
 17427 |       20 |        40 |

### Update Item Benchmark (Using Ecto Update)

See `bench/update_item_ecto.exs`.

For `pgbench`, the command was:

```
mix ecto.drop && mix ecto.create && mix ecto.migrate && mix run pgbench/seed_items.exs && pgbench -f pgbench/update_item_fast.sql -n -c 10 -j 5 -T 10 pghr
```

   ips | parallel | pool_size | What Changed? (PR #)
------:|---------:|----------:|:---
 24925 |        5 |        10 | **Initial `pgbench` test** (#4)   
 24217 |       10 |        10 |
 24730 |       20 |        10 |
 30425 |        5 |        20 |
 30515 |        5 |        40 |
  1652 |        5 |        10 | **Remove benchee from process** (#6)
  1879 |       10 |        10 |
  1930 |       20 |        10 |
  1847 |       10 |        40 |
  1875 |       20 |        40 |

### Update Item Benchmark (Using `Repo.update_all/3`)

See `bench/update_item_ecto_update_all.exs`.

For `pgbench`, the command was:

```
mix ecto.drop && mix ecto.create && mix ecto.migrate && mix run pgbench/seed_items.exs && pgbench -f pgbench/update_item_fast.sql -n -c 10 -j 5 -T 10 pghr
```

   ips | parallel | pool_size | What Changed? (PR #)
------:|---------:|----------:|:---
 24925 |        5 |        10 | **Initial `pgbench` test** (#4)   
 24217 |       10 |        10 |
 24730 |       20 |        10 |
 30425 |        5 |        20 |
 30515 |        5 |        40 |
  1843 |        5 |        10 | **Try `update_all`** (#7)
  2031 |       10 |        10 |
  2057 |       20 |        10 |
  1971 |       10 |        40 |
  2012 |       20 |        40 |

### Update Item Benchmark (Using Raw SQL Update)

See `bench/update_item_sql.exs`.

For `pgbench`, the command was:

```
mix ecto.drop && mix ecto.create && mix ecto.migrate && mix run pgbench/seed_items.exs && pgbench -f pgbench/update_item_fast.sql -n -c 10 -j 5 -T 10 pghr
```

   ips | parallel | pool_size | What Changed? (PR #)
------:|---------:|----------:|:---
 24925 |        5 |        10 | **Initial `pgbench` test** (#4)   
 24217 |       10 |        10 |
 24730 |       20 |        10 |
 30425 |        5 |        20 |
 30515 |        5 |        40 |
  1662 |        5 |        10 | **Remove benchee from process** (#6)
  1865 |       10 |        10 |
  1854 |       20 |        10 |
  1847 |       10 |        40 |
  1844 |       20 |        40 |
