defmodule AOC.Day12.NBodyProblemTest do
  alias AOC.Day12.NBodyProblem
  alias AOC.Day12.Moon

  use ExUnit.Case

  test "part 1 sample 1" do
    input = "
    <x=-1, y=0, z=2>
    <x=2, y=-10, z=-7>
    <x=4, y=-8, z=8>
    <x=3, y=5, z=-1>
    "

    results = NBodyProblem.part1(input, 10)
    moon = Map.get(results, 0)
    assert {2, 1, -3} == moon.position
    assert {-3, -2, 1} == moon.velocity
    assert 6 == Moon.potential_energy(moon)
    assert 6 == Moon.kinetic_energy(moon)
    assert 36 == Moon.total_energy(moon)
    moon = Map.get(results, 1)
    assert {1, -8, 0} == moon.position
    assert {-1, 1, 3} == moon.velocity
    assert 9 == Moon.potential_energy(moon)
    assert 5 == Moon.kinetic_energy(moon)
    assert 45 == Moon.total_energy(moon)
    moon = Map.get(results, 2)
    assert {3, -6, 1} == moon.position
    assert {3, 2, -3} == moon.velocity
    assert 10 == Moon.potential_energy(moon)
    assert 8 == Moon.kinetic_energy(moon)
    assert 80 == Moon.total_energy(moon)
    moon = Map.get(results, 3)
    assert {2, 0, 4} == moon.position
    assert {1, -1, -1} == moon.velocity
    assert 6 == Moon.potential_energy(moon)
    assert 3 == Moon.kinetic_energy(moon)
    assert 18 == Moon.total_energy(moon)

    assert 179 == NBodyProblem.sum_total_energy(results)

    assert 2772 == NBodyProblem.part2(input)
  end

  test "part 1 sample 2" do
    input = "
    <x=-8, y=-10, z=0>
    <x=5, y=5, z=10>
    <x=2, y=-7, z=3>
    <x=9, y=-8, z=-3>
    "

    results = NBodyProblem.part1(input, 100)
    assert 1940 == NBodyProblem.sum_total_energy(results)
  end

  test "part 1" do
    input = NBodyProblem.read_input("./resources/day12_part1_input.txt")
    results = NBodyProblem.part1(input, 1000)
    assert 7471 == NBodyProblem.sum_total_energy(results)
  end

  test "part 2" do
    input = NBodyProblem.read_input("./resources/day12_part1_input.txt")
    assert 376_243_355_967_784 == NBodyProblem.part2(input)
  end
end
