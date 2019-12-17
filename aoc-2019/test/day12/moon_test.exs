defmodule AOC.Day12.MoonTest do
  alias AOC.Day12.Moon

  use ExUnit.Case

  test "apply gravity to velocity" do
    m1 = Moon.new(0, {3, 0, 0}, {0, 0, 0})
    m2 = Moon.new(1, {5, 0, 0}, {0, 0, 0})

    {new_m1, new_m2} = Moon.apply_gravity_to_velocity({m1, m2})

    assert {1, 0, 0} == new_m1.velocity
    assert {-1, 0, 0} == new_m2.velocity
  end
end
