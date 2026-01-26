defmodule NitTest do
  use ExUnit.Case
  doctest Nit

  test "greets the world" do
    assert Nit.hello() == :world
  end
end
