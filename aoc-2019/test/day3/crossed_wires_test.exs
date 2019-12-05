defmodule AOC.Day3.CrossedWiresTest do
  alias AOC.Day3.CrossedWires

  use ExUnit.Case

  @moduledoc false

  test "part 1 example 1" do
    raw_w1 = ["R8","U5","L5","D3"]
    raw_w2 = ["U7","R6","D4","L4"]
    expected = 6

    [w1, w2] = CrossedWires.process_input([raw_w1, raw_w2])
    result = CrossedWires.find_intersections(w1, w2)
             |> Enum.min_by(&(CrossedWires.manhattan_distance(&1, {0,0})))
             |> CrossedWires.manhattan_distance({0,0})

    assert expected == result
  end

  test "part 1 example 2" do
    raw_w1 = ["R75","D30","R83","U83","L12","D49","R71","U7","L72"]
    raw_w2 = ["U62","R66","U55","R34","D71","R55","D58","R83"]
    expected = 159

    [w1, w2] = CrossedWires.process_input([raw_w1, raw_w2])
    result = CrossedWires.find_intersections(w1, w2)
             |> IO.inspect
             |> Enum.min_by(&(CrossedWires.manhattan_distance(&1, {0,0})))
             |> CrossedWires.manhattan_distance({0,0})

    assert expected == result
  end
#
#  test "part 1" do
#
#  end
end