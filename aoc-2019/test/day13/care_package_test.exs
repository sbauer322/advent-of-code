defmodule AOC.Day13.CarePackageTest do
  alias AOC.Day13.CarePackage

  use ExUnit.Case

  @moduledoc false

  test "part 1" do
    result = CarePackage.part1("./resources/day13_part1_input.txt")
    assert 260 == result
  end

  test "part 2" do
    # Commenting out as it times out from all the manual user input... have to run through iex.
    # Total score is 12952
    # result = CarePackage.part2("./resources/day13_part1_input.txt")
  end
end
