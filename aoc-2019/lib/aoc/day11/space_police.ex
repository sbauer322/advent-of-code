defmodule AOC.Day11.SpacePolice do
  alias AOC.Day11.Intcode

  @moduledoc false

  @type grid :: map
  @type point :: {integer, integer}

  def part1(path) do
    Intcode.stream_puzzle_input(path)
    |> Intcode.puzzle_input_to_map()
    |> paint(%{{0, 0} => {0, 0}}, {0, 0}, :north)
    |> count_painted_panels()
  end

  def part2(path) do
    Intcode.stream_puzzle_input(path)
    |> Intcode.puzzle_input_to_map()
    |> paint(%{{0, 0} => {1, 0}}, {0, 0}, :north)
    |> print()
  end

  def read_program_input(path) do
    File.read!(path)
    |> String.trim()
    |> String.split(",")
  end

  @spec read_grid(grid, point) :: {integer, integer}
  def read_grid(grid, location) do
    Map.get(grid, location, {0, 0})
  end

  @spec update_grid(grid, point, integer) :: grid
  def update_grid(grid, location, value) when is_integer(value) do
    {_old_value, num_painted} = read_grid(grid, location)
    Map.put(grid, location, {value, num_painted + 1})
  end

  def rotate_and_move(location, facing, rotation) when is_atom(facing) and is_integer(rotation) do
    rotation =
      case rotation do
        0 -> :left
        1 -> :right
      end

    new_facing = rotate(facing, rotation)
    new_location = move(location, new_facing)
    {new_location, new_facing}
  end

  def move(location, facing) do
    {x, y} = location

    case facing do
      :north -> {x, y + 1}
      :east -> {x + 1, y}
      :south -> {x, y - 1}
      :west -> {x - 1, y}
    end
  end

  def rotate(facing, :left) do
    case facing do
      :north -> :west
      :east -> :north
      :south -> :east
      :west -> :south
    end
  end

  def rotate(facing, :right) do
    case facing do
      :north -> :east
      :east -> :south
      :south -> :west
      :west -> :north
    end
  end

  def paint(memory, grid, location, facing) do
    {color, _num_painted} = read_grid(grid, location)
    memory = Intcode.append_input(memory, color)

    with {:waiting, memory} <- Intcode.compute(memory),
         {[new_color, rotation], memory} <- Intcode.empty_outputs(memory),
         grid <- update_grid(grid, location, new_color),
         {location, facing} <- rotate_and_move(location, facing, rotation) do
      paint(memory, grid, location, facing)
    else
      {:error, _memory} ->
        :error_compute

      {:terminate, _memory} ->
        grid
    end
  end

  def count_painted_panels(grid) do
    map_size(grid)
  end

  def print(grid) do
    {{min_x, min_y}, {max_x, max_y}} =
      Map.keys(grid)
      |> Enum.reduce({{0, 0}, {0, 0}}, fn {x, y}, {{min_x, min_y}, {max_x, max_y}} ->
        min_x =
          if x < min_x do
            x
          else
            min_x
          end

        min_y =
          if y < min_y do
            y
          else
            min_y
          end

        max_x =
          if x > max_x do
            x
          else
            max_x
          end

        max_y =
          if y > max_y do
            y
          else
            max_y
          end

        {{min_x, min_y}, {max_x, max_y}}
      end)

    IO.puts("")

    Enum.each(max_y..min_y, fn y ->
      Enum.each(min_x..max_x, fn x ->
        {color, _num_painted} = read_grid(grid, {x, y})

        if color == 0 do
          IO.write("   ")
        else
          IO.write(" # ")
        end
      end)

      IO.puts("")
    end)

    :ok
  end
end
