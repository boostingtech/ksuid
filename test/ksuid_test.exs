defmodule KsuidTest do
  use ExUnit.Case
  doctest Ksuid

  test "greets the world" do
    assert Ksuid.hello() == :world
  end
end
