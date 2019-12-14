defmodule AOC.Day7.IntcodeTest do
  alias AOC.Day7.Intcode

  use ExUnit.Case

  @moduledoc false

  test "parameter mode" do
    input = ["1002", "4", "3", "4", "33"]

    {_state, memory} =
      Intcode.puzzle_input_to_map(input)
      |> Intcode.compute()

    assert [] == Intcode.read_outputs(memory)
  end

  test "valid program with negative numbers" do
    input = ["1101", "100", "-1", "4", "0"]

    {_state, memory} =
      Intcode.puzzle_input_to_map(input)
      |> Intcode.compute()

    assert [] == Intcode.read_outputs(memory)
  end

  test "If input is 8, output is 1. Otherwise 0." do
    puzzle_input = ["3", "9", "8", "9", "10", "9", "4", "9", "99", "-1", "8"]

    user_input = [8]

    {_state, memory} =
      Intcode.puzzle_input_to_map(puzzle_input, user_input)
      |> Intcode.compute()

    assert [1] == Intcode.read_outputs(memory)

    user_input = [1]

    {_state, memory} =
      Intcode.puzzle_input_to_map(puzzle_input, user_input)
      |> Intcode.compute()

    assert [0] == Intcode.read_outputs(memory)

    user_input = [10]

    {_state, memory} =
      Intcode.puzzle_input_to_map(puzzle_input, user_input)
      |> Intcode.compute()

    assert [0] == Intcode.read_outputs(memory)
  end

  test "If input is < 8, output is 1. Otherwise 0." do
    puzzle_input = ["3", "9", "7", "9", "10", "9", "4", "9", "99", "-1", "8"]

    user_input = [8]

    {_state, memory} =
      Intcode.puzzle_input_to_map(puzzle_input, user_input)
      |> Intcode.compute()

    assert [0] == Intcode.read_outputs(memory)

    user_input = [-34]

    {_state, memory} =
      Intcode.puzzle_input_to_map(puzzle_input, user_input)
      |> Intcode.compute()

    assert [1] == Intcode.read_outputs(memory)

    user_input = [11]

    {_state, memory} =
      Intcode.puzzle_input_to_map(puzzle_input, user_input)
      |> Intcode.compute()

    assert [0] == Intcode.read_outputs(memory)
  end

  test "Input is equal to 8; output 1 (if it is) or 0 (if it is not)" do
    puzzle_input = ["3", "3", "1108", "-1", "8", "3", "4", "3", "99"]

    user_input = [8]

    {_state, memory} =
      Intcode.puzzle_input_to_map(puzzle_input, user_input)
      |> Intcode.compute()

    assert [1] == Intcode.read_outputs(memory)

    user_input = [100]

    {_state, memory} =
      Intcode.puzzle_input_to_map(puzzle_input, user_input)
      |> Intcode.compute()

    assert [0] == Intcode.read_outputs(memory)

    user_input = [0]

    {_state, memory} =
      Intcode.puzzle_input_to_map(puzzle_input, user_input)
      |> Intcode.compute()

    assert [0] == Intcode.read_outputs(memory)
  end

  test "Input is less than 8; output 1 (if it is) or 0 (if it is not)" do
    puzzle_input = ["3", "3", "1107", "-1", "8", "3", "4", "3", "99"]

    user_input = [8]

    {_state, memory} =
      Intcode.puzzle_input_to_map(puzzle_input, user_input)
      |> Intcode.compute()

    assert [0] == Intcode.read_outputs(memory)

    user_input = [1]

    {_state, memory} =
      Intcode.puzzle_input_to_map(puzzle_input, user_input)
      |> Intcode.compute()

    assert [1] == Intcode.read_outputs(memory)

    user_input = [9]

    {_state, memory} =
      Intcode.puzzle_input_to_map(puzzle_input, user_input)
      |> Intcode.compute()

    assert [0] == Intcode.read_outputs(memory)
  end

  test "(position mode) Output 0 if the input was zero, or output 1 if the input was non-zero." do
    puzzle_input = ~w(3 12 6 12 15 1 13 14 13 4 13 99 -1 0 1 9)

    user_input = [0]

    {_state, memory} =
      Intcode.puzzle_input_to_map(puzzle_input, user_input)
      |> Intcode.compute()

    assert [0] == Intcode.read_outputs(memory)

    user_input = [1]

    {_state, memory} =
      Intcode.puzzle_input_to_map(puzzle_input, user_input)
      |> Intcode.compute()

    assert [1] == Intcode.read_outputs(memory)

    user_input = [99]

    {_state, memory} =
      Intcode.puzzle_input_to_map(puzzle_input, user_input)
      |> Intcode.compute()

    assert [1] == Intcode.read_outputs(memory)
  end

  test "(immediate mode) Output 0 if the input was zero or 1 if the input was non-zero." do
    puzzle_input = ~w(3 3 1105 -1 9 1101 0 0 12 4 12 99 1)

    user_input = [0]

    {_state, memory} =
      Intcode.puzzle_input_to_map(puzzle_input, user_input)
      |> Intcode.compute()

    assert [0] == Intcode.read_outputs(memory)

    user_input = [1]

    {_state, memory} =
      Intcode.puzzle_input_to_map(puzzle_input, user_input)
      |> Intcode.compute()

    assert [1] == Intcode.read_outputs(memory)

    user_input = [-1]

    {_state, memory} =
      Intcode.puzzle_input_to_map(puzzle_input, user_input)
      |> Intcode.compute()

    assert [1] == Intcode.read_outputs(memory)
  end

  test "large jump test" do
    # output 999 if the input value is below 8,
    # output 1000 if the input value is equal to 8,
    # or output 1001 if the input value is greater than 8.
    puzzle_input = ~w(3 21 1008 21 8 20 1005 20 22 107 8 21 20 1006 20 31
                  1106 0 36 98 0 0 1002 21 125 20 4 20 1105 1 46 104
                  999 1105 1 46 1101 1000 1 20 4 20 1105 1 46 98 99)

    user_input = [3]

    {_state, memory} =
      Intcode.puzzle_input_to_map(puzzle_input, user_input)
      |> Intcode.compute()

    assert [999] == Intcode.read_outputs(memory)

    user_input = [8]

    {_state, memory} =
      Intcode.puzzle_input_to_map(puzzle_input, user_input)
      |> Intcode.compute()

    assert [1_000] == Intcode.read_outputs(memory)

    user_input = [79]

    {_state, memory} =
      Intcode.puzzle_input_to_map(puzzle_input, user_input)
      |> Intcode.compute()

    assert [1_001] == Intcode.read_outputs(memory)
  end

  test "thruster signal max 43210" do
    puzzle_input = ~w(3 15 3 16 1002 16 10 16 1 16 15 15 4 15 99 0 0)
    output = Intcode.amplifiers(puzzle_input)
    assert {[4, 3, 2, 1, 0], 43_210} == output
  end

  test "thruster signal max 54321" do
    puzzle_input = ~w(3 23 3 24 1002 24 10 24 1002 23 -1 23 101 5 23 23 1 24 23 23 4 23 99 0 0)
    output = Intcode.amplifiers(puzzle_input)
    assert {[0, 1, 2, 3, 4], 54_321} == output
  end

  test "thruster signal max 65210" do
    puzzle_input =
      ~w(3 31 3 32 1002 32 10 32 1001 31 -2 31 1007 31 0 33 1002 33 7 33 1 33 31 31 1 32 31 31 4 31 99 0 0 0)

    output = Intcode.amplifiers(puzzle_input)
    assert {[1, 0, 4, 3, 2], 65_210} == output
  end

  test "feedback loop max thruster signal 139629729" do
    puzzle_input =
      ~w(3 26 1001 26 -4 26 3 27 1002 27 2 27 1 27 26 27 4 27 1001 28 -1 28 1005 28 6 99 0 0 5)

    output = Intcode.amplifiers_feedback(puzzle_input)
    assert {[9, 8, 7, 6, 5], 139_629_729} == output
  end

  test "feedback loop max thruster signal 18216" do
    puzzle_input =
      ~w(3 52 1001 52 -5 52 3 53 1 52 56 54 1007 54 5 55 1005 55 26 1001 54 -5 54 1105 1 12 1 53 54 53 1008 54 0 55 1001 55 1 55 2 53 55 53 4 53 1001 56 -1 56 1005 56 6 99 0 0 0 0 10)

    output = Intcode.amplifiers_feedback(puzzle_input)
    assert {[9, 7, 8, 5, 6], 18_216} == output
  end

  test "part 1" do
    output = Intcode.part1("./resources/day7_part1_input.txt")
    assert {[0, 2, 1, 4, 3], 255_840} == output
  end

  test "part 2" do
    output = Intcode.part2("./resources/day7_part1_input.txt")
    assert {[7, 5, 9, 8, 6], 84_088_865} == output
  end
end
