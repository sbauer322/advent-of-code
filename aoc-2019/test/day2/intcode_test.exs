defmodule AOC.Day2.IntcodeTest do
  alias AOC.Day2.Intcode

  use ExUnit.Case

  @moduledoc false

  test "examples" do
    input = ["1", "9", "10", "3", "2", "3", "11", "0", "99", "30", "40", "50"]

    result =
      Intcode.input_to_map(input)
      |> Intcode.compute()

    assert 3500 == result

    input = ["1", "0", "0", "0", "99"]

    result =
      Intcode.input_to_map(input)
      |> Intcode.compute()

    assert 2 == result

    input = ["2", "3", "0", "3", "99"]

    result =
      Intcode.input_to_map(input)
      |> Intcode.compute()

    assert 2 == result

    input = ["2", "4", "4", "5", "99", "0"]

    result =
      Intcode.input_to_map(input)
      |> Intcode.compute()

    assert 2 == result

    input = ["1", "1", "1", "4", "99", "5", "6", "0", "99"]

    result =
      Intcode.input_to_map(input)
      |> Intcode.compute()

    assert 30 == result
  end

  test "part 1" do
    result = Intcode.part1("./resources/day2_part1_input.txt")
    assert 3_706_713 == result
  end

  test "part 2 example" do
    result = Intcode.part2("./resources/day2_part1_input.txt", 3_706_713)
    assert 1202 == result
  end

  test "part 2" do
    result = Intcode.part2("./resources/day2_part1_input.txt", 19_690_720)
    assert 8609 == result
  end
end
