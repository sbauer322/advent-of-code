defmodule AOC.Day11.SpacePoliceTest do
  alias AOC.Day11.SpacePolice

  use ExUnit.Case

  @moduledoc false

  test "read and update grid" do
    assert {0, 0} == SpacePolice.read_grid(%{}, {3, 3})
    assert {1, 1} == SpacePolice.read_grid(%{{2, 2} => {1, 1}}, {2, 2})
  end

  test "move and rotate" do
    assert {{-1, 0}, :west} == SpacePolice.rotate_and_move({0, 0}, :north, 0)
    assert {{0, 1}, :north} == SpacePolice.rotate_and_move({0, 0}, :east, 0)
    assert {{1, 0}, :east} == SpacePolice.rotate_and_move({0, 0}, :south, 0)
    assert {{0, -1}, :south} == SpacePolice.rotate_and_move({0, 0}, :west, 0)

    assert {{1, 0}, :east} == SpacePolice.rotate_and_move({0, 0}, :north, 1)
    assert {{0, -1}, :south} == SpacePolice.rotate_and_move({0, 0}, :east, 1)
    assert {{-1, 0}, :west} == SpacePolice.rotate_and_move({0, 0}, :south, 1)
    assert {{0, 1}, :north} == SpacePolice.rotate_and_move({0, 0}, :west, 1)
  end

  test "go in a circle" do
    {location, facing} = SpacePolice.rotate_and_move({0, 0}, :north, 0)
    {location, facing} = SpacePolice.rotate_and_move(location, facing, 0)
    {location, facing} = SpacePolice.rotate_and_move(location, facing, 0)
    {location, facing} = SpacePolice.rotate_and_move(location, facing, 0)

    assert {{0, 0}, :north} = {location, facing}
  end

  test "painted panel count" do
    grid =
      SpacePolice.update_grid(%{}, {0, 0}, 1)
      |> SpacePolice.update_grid({-1, 0}, 0)
      |> SpacePolice.update_grid({-1, -1}, 1)
      |> SpacePolice.update_grid({0, -1}, 1)
      |> SpacePolice.update_grid({0, 0}, 0)
      |> SpacePolice.update_grid({1, 0}, 1)
      |> SpacePolice.update_grid({1, 1}, 1)

    assert 6 == SpacePolice.count_painted_panels(grid)
  end

  test "part 1" do
    result = SpacePolice.part1("./resources/day11_part1_input.txt")
    assert 2392 == result
  end

  test "part 2" do
    #    result = SpacePolice.part2("./resources/day11_part1_input.txt")
    #    Prints 'EGBHLEUE'
    #    assert :ok == result
  end
end
