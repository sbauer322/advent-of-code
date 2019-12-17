defmodule AOC.Day13.CarePackage do
  alias AOC.Day13.Intcode

  @moduledoc """
  Had to get clarification that we are supposed to wait until the program finishes before gathering output.
  """

  @type grid :: map
  @type point :: {integer, integer}

  def part1(path) do
    Intcode.stream_puzzle_input(path)
    |> Intcode.puzzle_input_to_map()
    |> compute_part1(%{}, 0)
    |> process_outputs()
    |> count_walls()
  end

  def part2(path, use_prev_inputs \\ false) do
    Intcode.stream_puzzle_input(path)
    |> Intcode.puzzle_input_to_map()
    |> (&Intcode.update(&1, {0, 0}, 2)).()
    |> compute_part2(%{}, 0)
    |> process_outputs()
    |> print()
  end

  def read_program_input(path) do
    File.read!(path)
    |> String.trim()
    |> String.split(",")
  end

  def compute_part1(memory, grid \\ %{}, score \\ 0) do
    with {:waiting, memory} <- Intcode.compute(memory),
         {outputs, memory} <- Intcode.empty_outputs(memory),
         {grid, score} <- process_outputs({outputs, grid, score}),
         {next_input, memory} <- user_input(memory, grid, score),
         memory <- Intcode.append_input(memory, next_input) do
      compute_part1(memory, grid, score)
    else
      {:error, _memory} ->
        :error_compute

      {:terminate, memory} ->
          {outputs, memory} = Intcode.empty_outputs(memory)
          {outputs, grid, score}
    end
  end

  def compute_part2(memory, grid \\ %{}, score \\ 0, prev_states \\ []) do
    with {:waiting, memory} <- Intcode.compute(memory),
         {outputs, memory} <- Intcode.empty_outputs(memory),
         {grid, score} <- process_outputs({outputs, grid, score}),
         {next_input, memory} <- user_input(memory, grid, score),
         memory <- Intcode.append_input(memory, next_input) do
      IO.puts("awaiting input")
      prev_states = [{memory, grid, score} | prev_states]
      compute_part2(memory, grid, score, prev_states)
    else
      {:error, _memory} ->
        :error_compute

      {:terminate, memory} ->
        prev_states = [{memory, grid, score} | prev_states]
        {rewind_memory, rewind_grid, rewind_score} = rewind(prev_states)

        if memory == rewind_memory do
          {outputs, memory} = Intcode.empty_outputs(memory)
          {outputs, grid, score}
        else
          compute_part2(rewind_memory, rewind_grid, rewind_score, prev_states)
        end
    end
  end

  def rewind(memories) do
    index =
      IO.gets("Rewind? How far? 0 to stop.\n")
      |> String.trim()
      |> String.to_integer()

    Enum.at(memories, index)
  end

  def user_input(memory, grid, score) do
    print({grid, score})

    IO.puts("Enter -1, 0, 1 for Left, Neutral, Right:")

    next_input =
      IO.read(:line)
      |> String.trim()

    next_input =
      case next_input do
        "-1" -> -1
        "0" -> 0
        "1" -> 1
        _ -> 0
      end

    {next_input, memory}
  end

  @spec read_grid(grid, point) :: {integer, integer}
  def read_grid(grid, location) do
    Map.get(grid, location, -1)
  end

  @spec update_grid(grid, point, integer) :: grid
  def update_grid(grid, location, value) when is_integer(value) do
    #    {_old_value, num_painted} = read_grid(grid, location)
    Map.put(grid, location, value)
  end

  def process_outputs({outputs, grid, score}) do
    Enum.chunk_every(outputs, 3)
    |> Enum.reduce({grid, score}, fn [x, y, tile], {grid, score} ->
      if {-1, 0} == {x, y} do
        {grid, tile}
      else
        grid = update_grid(grid, {x, y}, tile)
        {grid, score}
      end
    end)
  end

  def count_walls({grid, score}) do
    Map.values(grid)
    |> Enum.reduce(0, fn value, sum ->
      if value == 2 do
        sum + 1
      else
        sum
      end
    end)
  end

  def print({grid, score}) do
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
        value = read_grid(grid, {x, y})

        output =
          cond do
            value == -1 -> " ? "
            value == 0 -> " _ "
            value == 1 -> " W "
            value == 2 -> " # "
            value == 3 -> "vvv"
            value == 4 -> " * "
            true -> " ? "
          end

        IO.write(output)
      end)

      IO.puts("")
    end)

    IO.puts("Score: #{score}")

    :ok
  end
end
