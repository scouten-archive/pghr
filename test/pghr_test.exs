defmodule PghrTest do
  use ExUnit.Case
  doctest Pghr

  test "greets the world" do
    assert Pghr.hello() == :world
  end
end
