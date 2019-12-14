defmodule AOC.Day10.MonitoringStation do
  @moduledoc false

  @type point :: {integer, integer}

  def read_puzzle_input(path) do
    File.read!(path)
  end

  def part1(input) do
    process_input(input)
    |> find_best_station_location()
  end

  def part2(input, origin) do
    result =
      process_input(input)
      |> vaporize_all(origin)

    if result != nil do
      {x, y} = result
      x * 100 + y
    else
      nil
    end
  end

  @spec process_input(String.t()) :: list(point)
  def process_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, y} ->
      row
      |> String.trim()
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.filter(fn {value, _x} ->
        value == "#"
      end)
      |> Enum.map(fn {_value, x} ->
        {x, y}
      end)
    end)
  end

  @spec find_best_station_location(list(point)) :: {point, integer}
  def find_best_station_location(positions) do
    positions
    |> Enum.reduce({nil, 0}, fn pos, {current, total} ->
      {asteroid, detected} = detect_asteroids(positions, pos) |> count_closest_asteroids(pos)

      if detected >= total do
        {asteroid, detected}
      else
        {current, total}
      end
    end)
  end

  @spec detect_asteroids(list(point), point) :: %{float => list(point)}
  def detect_asteroids(positions, origin) do
    build_position_angle_map(positions, origin)
    |> Enum.group_by(fn {_key, value} -> value end, fn {key, _value} -> key end)
  end

  @spec build_position_angle_map(list(point), point) :: %{point => float}
  def build_position_angle_map(positions, {x0, y0}) do
    positions
    |> Enum.reduce(%{}, fn {x1, y1}, acc ->
      x = x0 - x1
      y = y0 - y1
      angle = :math.atan2(x, y)

      Map.put(acc, {x1, y1}, angle)
    end)
  end

  @spec count_closest_asteroids(%{float => list(point)}, point) :: {point, integer}
  def count_closest_asteroids(angle_position_map, origin) do
    angle_position_map
    |> Map.values()
    |> Enum.map(fn values ->
      Enum.min_by(values, fn val ->
        manhattan_distance(val, origin)
      end)
    end)
    |> (&{origin, length(&1)}).()
  end

  @spec vaporize_all(list(point), point) :: integer | nil
  def vaporize_all(positions, origin) do
    clockwise = asteroids_by_clockwise_and_nearest(positions, origin)
    total_cycle = length(clockwise)
    vaporize(clockwise, 0, 0)
  end

  @spec vaporize(list(list(point)), integer, integer) :: point | nil
  def vaporize([], current, removed) do
    nil
  end

  def vaporize(ordered_asteroids, current, removed \\ 0) do
    total_cycle = length(ordered_asteroids)
    current = rem(current, total_cycle)
    angle_list = Enum.at(ordered_asteroids, current)

    cond do
      removed == 199 ->
        hd(angle_list)

      length(angle_list) == 1 ->
        ordered_asteroids = List.delete_at(ordered_asteroids, current)
        removed = removed + 1
        current = current
        vaporize(ordered_asteroids, current, removed)

      true ->
        [head | tail] = angle_list
        ordered_asteroids = List.replace_at(ordered_asteroids, current, tail)
        removed = removed + 1
        current = current + 1
        vaporize(ordered_asteroids, current, removed)
    end
  end

  @spec asteroids_by_clockwise_and_nearest(list(point), point) :: list(list(point))
  def asteroids_by_clockwise_and_nearest(positions, origin) do
    angle_position_map =
      build_position_angle_map(positions, origin)
      |> Enum.group_by(fn {_key, value} -> value end, fn {key, _value} -> key end)

    {left, right} =
      Enum.split_with(angle_position_map, fn {key, val} ->
        key <= 0
      end)

    left = wrap_angles_clockwise(left, origin)
    right = wrap_angles_clockwise(right, origin)

    left ++ right
  end

  @spec manhattan_distance(point, point) :: non_neg_integer
  def manhattan_distance({x1, y1}, {x2, y2}) do
    abs(y1 - y2) + abs(x1 - x2)
  end

  @spec wrap_angles_clockwise(list({float, list(point)}), point) :: list(list(point))
  def wrap_angles_clockwise(angle_positions, origin) do
    Enum.map(angle_positions, fn {angle, points} ->
      points =
        points
        |> List.delete(origin)
        |> Enum.sort(fn p1, p2 ->
          m1 = manhattan_distance(p1, origin)
          m2 = manhattan_distance(p2, origin)
          m1 < m2
        end)

      {angle, points}
    end)
    |> Enum.sort(fn p1, p2 ->
      {angle1, _points1} = p1
      {angle2, _points2} = p2
      angle1 > angle2
    end)
    |> Enum.map(fn {angle, points} ->
      points
    end)
  end
end
