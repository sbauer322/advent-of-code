defmodule AOC.Day6.OrbitChecksumTest do
  alias AOC.Day6.OrbitChecksum

  use ExUnit.Case

  @moduledoc false

  test "sample orbit calculate checksum" do
    input = "COM)B\nB)C\nC)D\nD)E\nE)F\nB)G\nG)H\nD)I\nE)J\nJ)K\nK)L\n"

    result =
      input
      |> OrbitChecksum.process_input()
      |> OrbitChecksum.child_to_parent_map()
      |> OrbitChecksum.checksum()

    assert 42 == result
  end

  test "sample orbit calculate orbital transfers" do
    input = "COM)B\nB)C\nC)D\nD)E\nE)F\nB)G\nG)H\nD)I\nE)J\nJ)K\nK)L\nK)YOU\nI)SAN\n"

    result =
      input
      |> OrbitChecksum.process_input()
      |> OrbitChecksum.neighbor_map()
      |> OrbitChecksum.depth_first_search("YOU", "SAN")
      |> OrbitChecksum.node_to_path()

    # Remove "YOU", "SAN", and the starting object
    result = length(result) - 3
    assert 4 == result
  end

  test "part 1" do
    result = OrbitChecksum.part1("./resources/day6_part1_input.txt")

    assert 144_909 == result
  end

  test "part 2" do
    result = OrbitChecksum.part2("./resources/day6_part1_input.txt")

    assert 259 == result
  end
end
