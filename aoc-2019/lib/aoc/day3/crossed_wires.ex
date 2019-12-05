defmodule AOC.Day3.CrossedWires do

  @moduledoc false

  def part1() do
    [w1, w2] =
      stream_input("./resources/day3_part1_input.txt")
      |> process_input()

    compute_part1(w1, w2)
  end

  def part2() do
  end

  def stream_input(path) do
    File.stream!(path)
    |> Enum.map(fn line ->
      line
      |> String.trim()
      |> String.split(",")
    end)
  end

  def process_input(lines) do
    Enum.map(lines, fn line ->
      line
      |> process_wire_input()
      |> points()
    end)
  end

  def compute_part1(w1, w2) do
    find_intersections(w1, w2)
    |> Enum.min_by(&manhattan_distance(&1, {0, 0}))
    |> manhattan_distance({0, 0})
  end

  def process_wire_input(wire) do
    wire
    |> Enum.map(fn vector ->
      {direction, magnitude} = String.split_at(vector, 1)
      direction = String.to_atom(direction)
      magnitude = String.to_integer(magnitude)
      {direction, magnitude}
    end)
  end

  def points(path) do
    path
    |> Enum.reduce([{0, 0}], fn {direction, quantity}, acc ->
      {x, y} = hd(acc)

      p =
        cond do
          :R == direction -> {x + quantity, y}
          :L == direction -> {x - quantity, y}
          :U == direction -> {x, y + quantity}
          :D == direction -> {x, y - quantity}
        end

      [p | acc]
    end)
    |> Enum.reverse()
  end

  @doc """
  Adapted from
  https://stackoverflow.com/a/24392281/3141194
  http://paulbourke.net/geometry/pointlineplane/javascript.txt
  """
  def segments_intersect([start1, end1], [start2, end2]) do
    {a, b} = start1
    {c, d} = end1
    {p, q} = start2
    {r, s} = end2
    determinate = (c - a) * (s - q) - (r - p) * (d - b)

    with true <- determinate != 0,
         lambda <- ((s - q) * (r - a) + (p - r) * (s - b)) / determinate,
         gamma <- ((b - d) * (r - a) + (c - a) * (s - b)) / determinate,
         true <- 0 < lambda && lambda < 1 and (0 < gamma && gamma < 1) do
      x = a + lambda * (c - a)
      y = b + lambda * (d - b)
      {x, y}
    else
      _ -> :none
    end
  end

  def find_intersections(w1, w2) do
    w1_segments = Enum.chunk_every(w1, 2, 1, :discard)
    w2_segments = Enum.chunk_every(w2, 2, 1, :discard)

    Enum.reduce(w1_segments, [], fn segment1, acc ->
      intersections =
        Enum.reduce(w2_segments, [], fn segment2, acc ->
          intersections = segments_intersect(segment1, segment2)

          if :none == intersections do
            acc
          else
            [intersections | acc]
          end
        end)

      intersections ++ acc
    end)
  end

  @spec manhattan_distance({integer, integer}, {integer, integer}) :: non_neg_integer
  def manhattan_distance({x1, y1}, {x2, y2}) do
    abs(y1 - y2) + abs(x1 - x2)
  end
end
