defmodule AOC.Day1.FuelEquation do
  def part1() do
    stream_input("./resources/day1_part1_input.txt")
    |> total_fuel(:simple)
  end

  def part2() do
    stream_input("./resources/day1_part1_input.txt")
    |> total_fuel(:advanced)
  end

  def stream_input(path) do
    File.stream!(path)
    |> Stream.map(fn line ->
      line
      |> String.trim()
      |> String.to_integer()
    end)
  end

  @spec total_fuel(%Stream{}, atom) :: non_neg_integer
  def total_fuel(modules, fuel_type) do
    modules
    |> Stream.map(fn module ->
      fuel(module, fuel_type)
    end)
    |> Enum.sum()
  end

  @spec fuel(non_neg_integer, atom) :: non_neg_integer
  def fuel(mass, :simple) do
    div(mass, 3) - 2
  end

  def fuel(mass, :advanced) do
    fuel_mass = div(mass, 3) - 2

    case fuel_mass > 0 do
      true -> fuel_mass + fuel(fuel_mass, :advanced)
      false -> 0
    end
  end
end
