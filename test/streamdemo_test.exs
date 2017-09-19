defmodule StreamdemoTest do
  use ExUnit.Case
  doctest Streamdemo

  test "greets the world" do
    assert Streamdemo.hello() == :world
  end
end
