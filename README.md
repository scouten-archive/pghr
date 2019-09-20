# Pghr

Quick 'n' dirty test to see how Ecto + Postgres behave in specific microbenchmarks.

## Test Methodology


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

The benchmark results described below were run on my 2015-era MacBook Pro. Tests were always run for 10 seconds with a 2-second warm-up. Varying levels of parallelism were used and noted in the test results.

~~I want to emphasize a performance correlation I've observed on update with size of the existing table, so I'm removing previous results. All results here are run with 10 parallel clients and a pool size of 40, which had been shown in previous tests to be among the "best" configurations.~~

With `Enum.random/1` removed from the test, this claim is disproven. Still seeing a constant difference between `pgbench` and Ecto, but there are leads to follow.

### Create Item Benchmark

Ecto:

```
$ mix ecto.drop && mix ecto.create && mix ecto.migrate && mix run bench/create_item_fast.exs 
```

Pgbench:

```
$ mix ecto.drop && mix ecto.create && mix ecto.migrate && pgbench -f pgbench/create_item_fast.sql -n -c 40 -j 10 -T 10 pghr
```

   ips | duration | Comments
------:|---------:|:---
 14864 |       10 | Ecto
 14794 |       30 |
 14521 |      100 |
 28058 |       10 | pgbench
 27231 |       30 |
 26002 |      100 |
 
### Update Item Benchmark (Using Raw SQL Update)

Ecto:

```
$ mix ecto.drop && mix ecto.create && mix ecto.migrate && mix run bench/update_item_sql.exs
```

Pgbench:

```
$ mix ecto.drop && mix ecto.create && mix ecto.migrate && pgbench -f pgbench/update_item_fast.sql -n -c 40 -j 10 -T 10 pghr
```

   ips | seed size | duration | Comments
------:|----------:|---------:|:---
 17371 |       500 |       30 | Ecto
 17067 |      5000 |       30 |
 16706 |     50000 |       30 |
 16046 |    500000 |       30 |
 27972 |       500 |       30 | pgbench
 27486 |      5000 |       30 |
 26466 |     50000 |       30 |
 26309 |    500000 |       30 |
