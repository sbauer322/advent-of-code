defmodule AOC.Day5.IntcodeTest do
  alias AOC.Day5.Intcode

  use ExUnit.Case

  @moduledoc false

  test "parameter mode" do
    input = ["1002","4","3","4","33"]
    result =
      Intcode.input_to_map(input)
      |> Intcode.compute()

    assert 2 == result
  end

  test "valid program with negative numbers" do
    input = ["1101","100","-1","4","0"]
    Intcode.input_to_map(input)
      |> Intcode.compute()
  end

#  test "part 1" do
#    IO.puts("Enter '1' for the first input. Final output should be '12440243'")
#    result = Intcode.part1("./resources/day5_part1_input.txt")
#  end

  test "part 2" do
    IO.puts("Enter '1' for the first input. Final output should be '12440243'")
    result = Intcode.part1("./resources/day5_part1_input.txt")
  end
end