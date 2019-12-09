defmodule AOC.Day5.IntcodeTest do
  alias AOC.Day5.Intcode

  use ExUnit.Case

  @moduledoc false

  test "parameter mode" do
    input = ["1002", "4", "3", "4", "33"]

    outputs =
      Intcode.puzzle_input_to_map(input)
      |> Intcode.compute()

    assert [] == outputs
  end

  test "valid program with negative numbers" do
    input = ["1101", "100", "-1", "4", "0"]

    outputs =
      Intcode.puzzle_input_to_map(input)
      |> Intcode.compute()

    assert [] == outputs
  end

  test "If input is 8, output is 1. Otherwise 0." do
    puzzle_input = ["3", "9", "8", "9", "10", "9", "4", "9", "99", "-1", "8"]

    user_input = [8]

    outputs =
      Intcode.puzzle_input_to_map(puzzle_input, user_input)
      |> Intcode.compute()

    assert [1] == outputs

    user_input = [1]

    outputs =
      Intcode.puzzle_input_to_map(puzzle_input, user_input)
      |> Intcode.compute()

    assert [0] == outputs

    user_input = [10]

    outputs =
      Intcode.puzzle_input_to_map(puzzle_input, user_input)
      |> Intcode.compute()

    assert [0] == outputs
  end

  test "If input is < 8, output is 1. Otherwise 0." do
    puzzle_input = ["3", "9", "7", "9", "10", "9", "4", "9", "99", "-1", "8"]

    user_input = [8]

    outputs =
      Intcode.puzzle_input_to_map(puzzle_input, user_input)
      |> Intcode.compute()

    assert [0] == outputs

    user_input = [-34]

    outputs =
      Intcode.puzzle_input_to_map(puzzle_input, user_input)
      |> Intcode.compute()

    assert [1] == outputs

    user_input = [11]

    outputs =
      Intcode.puzzle_input_to_map(puzzle_input, user_input)
      |> Intcode.compute()

    assert [0] == outputs
  end

  test "Input is equal to 8; output 1 (if it is) or 0 (if it is not)" do
    puzzle_input = ["3", "3", "1108", "-1", "8", "3", "4", "3", "99"]

    user_input = [8]

    outputs =
      Intcode.puzzle_input_to_map(puzzle_input, user_input)
      |> Intcode.compute()

    assert [1] == outputs

    user_input = [100]

    outputs =
      Intcode.puzzle_input_to_map(puzzle_input, user_input)
      |> Intcode.compute()

    assert [0] == outputs

    user_input = [0]

    outputs =
      Intcode.puzzle_input_to_map(puzzle_input, user_input)
      |> Intcode.compute()

    assert [0] == outputs
  end

  test "Input is less than 8; output 1 (if it is) or 0 (if it is not)" do
    puzzle_input = ["3", "3", "1107", "-1", "8", "3", "4", "3", "99"]

    user_input = [8]

    outputs =
      Intcode.puzzle_input_to_map(puzzle_input, user_input)
      |> Intcode.compute()

    assert [0] == outputs

    user_input = [1]

    outputs =
      Intcode.puzzle_input_to_map(puzzle_input, user_input)
      |> Intcode.compute()

    assert [1] == outputs

    user_input = [9]

    outputs =
      Intcode.puzzle_input_to_map(puzzle_input, user_input)
      |> Intcode.compute()

    assert [0] == outputs
  end

  test "(position mode) Output 0 if the input was zero, or output 1 if the input was non-zero." do
    puzzle_input = ~w(3 12 6 12 15 1 13 14 13 4 13 99 -1 0 1 9)

    user_input = [0]

    outputs =
      Intcode.puzzle_input_to_map(puzzle_input, user_input)
      |> Intcode.compute()

    assert [0] == outputs

    user_input = [1]

    outputs =
      Intcode.puzzle_input_to_map(puzzle_input, user_input)
      |> Intcode.compute()

    assert [1] == outputs

    user_input = [99]

    outputs =
      Intcode.puzzle_input_to_map(puzzle_input, user_input)
      |> Intcode.compute()

    assert [1] == outputs
  end

  test "(immediate mode) Output 0 if the input was zero or 1 if the input was non-zero." do
    puzzle_input = ~w(3 3 1105 -1 9 1101 0 0 12 4 12 99 1)

    user_input = [0]

    outputs =
      Intcode.puzzle_input_to_map(puzzle_input, user_input)
      |> Intcode.compute()

    assert [0] == outputs

    user_input = [1]

    outputs =
      Intcode.puzzle_input_to_map(puzzle_input, user_input)
      |> Intcode.compute()

    assert [1] == outputs

    user_input = [-1]

    outputs =
      Intcode.puzzle_input_to_map(puzzle_input, user_input)
      |> Intcode.compute()

    assert [1] == outputs
  end

  test "large jump test" do
    # output 999 if the input value is below 8,
    # output 1000 if the input value is equal to 8,
    # or output 1001 if the input value is greater than 8.
    puzzle_input = ~w(3 21 1008 21 8 20 1005 20 22 107 8 21 20 1006 20 31
                1106 0 36 98 0 0 1002 21 125 20 4 20 1105 1 46 104
                999 1105 1 46 1101 1000 1 20 4 20 1105 1 46 98 99)

    user_input = [3]

    outputs =
      Intcode.puzzle_input_to_map(puzzle_input, user_input)
      |> Intcode.compute()

    assert [999] == outputs

    user_input = [8]

    outputs =
      Intcode.puzzle_input_to_map(puzzle_input, user_input)
      |> Intcode.compute()

    assert [1_000] == outputs

    user_input = [79]

    outputs =
      Intcode.puzzle_input_to_map(puzzle_input, user_input)
      |> Intcode.compute()

    assert [1_001] == outputs
  end

  test "part 1" do
    user_input = [1]

    last_output =
      Intcode.part1("./resources/day5_part1_input.txt", user_input)
      |> Enum.reverse()
      |> hd()

    assert 12_440_243 == last_output
  end

  test "part 2" do
    user_input = [5]

    last_output =
      Intcode.part2("./resources/day5_part1_input.txt", user_input)
      |> Enum.reverse()
      |> hd()

    assert 15_486_302 == last_output
  end
end
