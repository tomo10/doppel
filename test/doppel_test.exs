defmodule DoppelTest do
  use ExUnit.Case
  doctest Doppel

  test "greets the world" do
    assert Doppel.hello() == :world
  end
end
