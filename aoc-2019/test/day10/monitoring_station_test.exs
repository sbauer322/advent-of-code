defmodule AOC.Day10.MonitoringStationTest do
  alias AOC.Day10.MonitoringStation

  use ExUnit.Case

  @moduledoc false

  test "sample" do
    input = "
    .#..#
    .....
    #####
    ....#
    ...##
    "

    result = MonitoringStation.part1(input)
    assert {{3, 4}, 8} == result
  end

  test "best is 5,8 with 33" do
    input = "
    ......#.#.
    #..#.#....
    ..#######.
    .#.#.###..
    .#..#.....
    ..#....#.#
    #..#....#.
    .##.#..###
    ##...#..#.
    .#....####
    "

    result = MonitoringStation.part1(input)
    assert {{5, 8}, 33} == result
  end

  test "Best is 1,2 with 35" do
    input = "
    #.#...#.#.
    .###....#.
    .#....#...
    ##.#.#.#.#
    ....#.#.#.
    .##..###.#
    ..#...##..
    ..##....##
    ......#...
    .####.###.
    "

    result = MonitoringStation.part1(input)
    assert {{1, 2}, 35} == result
  end

  test "Best is 6,3 with 41" do
    input = "
    .#..#..###
    ####.###.#
    ....###.#.
    ..###.##.#
    ##.##.#.#.
    ....###..#
    ..#.#..#.#
    #..#.#.###
    .##...##.#
    .....#.#..
    "

    result = MonitoringStation.part1(input)
    assert {{6, 3}, 41} == result
  end

  test "Best is 11,13 with 210... 200th vaporized is 8,2 " do
    input = "
    .#..##.###...#######
    ##.############..##.
    .#.######.########.#
    .###.#######.####.#.
    #####.##.#.##.###.##
    ..#####..#.#########
    ####################
    #.####....###.#.#.##
    ##.#################
    #####.##.###..####..
    ..######..##.#######
    ####.##.####...##..#
    .#####..#.######.###
    ##...#.##########...
    #.##########.#######
    .####.#.###.###.#.##
    ....##.##.###..#####
    .#.#.###########.###
    #.#.#.#####.####.###
    ###.##.####.##.#..##
    "

    result = MonitoringStation.part1(input)
    assert {{11, 13}, 210} == result
    result = MonitoringStation.part2(input, {11, 13})
    assert 802 == result
  end

  test "vaporize" do
    input = "
    .#....#####...#..
    ##...##.#####..##
    ##...#...#.#####.
    ..#.....X...###..
    ..#.#.....#....##
    "

    result = MonitoringStation.part2(input, {8, 3})
    assert nil == result
  end

  test "part 1" do
    result =
      MonitoringStation.read_puzzle_input("./resources/day10_part1_input.txt")
      |> MonitoringStation.part1()

    assert {{17, 22}, 288} == result
  end

  test "part 2" do
    result =
      MonitoringStation.read_puzzle_input("./resources/day10_part1_input.txt")
      |> MonitoringStation.part2({17, 22})

    assert 616 == result
  end
end
