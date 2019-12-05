defmodule AOC.Day1.FuelEquationTest do
  alias AOC.Day1.FuelEquation
  use ExUnit.Case

  @moduledoc false

  test "part 1" do
    assert 3282386 == FuelEquation.part1()
  end

  test "part 2" do
    assert 4920708 == FuelEquation.part2()
  end

  test "total_fuel" do
    assert 34241 == FuelEquation.total_fuel([12, 14, 1969, 100756], :simple)
#    assert 52319 == FuelEquation.total_fuel([12, 14, 1969, 100756], :advanced)
  end

  test "fuel required" do
    assert 2 == FuelEquation.fuel(12, :simple)
    assert 2 == FuelEquation.fuel(14, :simple)
    assert 654 == FuelEquation.fuel(1969, :simple)
    assert 33583 == FuelEquation.fuel(100756, :simple)

    assert 2 == FuelEquation.fuel(12, :advanced)
    assert 2 == FuelEquation.fuel(14, :advanced)
    assert 966 == FuelEquation.fuel(1969, :advanced)
    assert 50346 == FuelEquation.fuel(100756, :advanced)
  end
end