defmodule AOC.Day4.SecureContainer do
  @input_min 134_792
  @input_max 675_810

  def part1() do
    @input_min..@input_max
    |> Enum.filter(fn value ->
      with digits <- Integer.digits(value),
           false <- digits_decrease?(digits),
           true <- two_adjacent_digits_same?(digits),
           true <- in_bounds?(value) do
        true
      else
        _ -> false
      end
    end)
    |> length()
  end

  def part2() do
    @input_min..@input_max
    |> Enum.filter(fn value ->
      with digits <- Integer.digits(value),
           false <- digits_decrease?(digits),
           true <- distinct_two_adjacent_digits?(digits),
           true <- in_bounds?(value) do
        true
      else
        _ -> false
      end
    end)
    |> length()
  end

  def in_bounds?(value) do
    @input_min <= value and value <= @input_max
  end

  def distinct_two_adjacent_digits?(digits) do
    digits
    |> Stream.chunk_every(2, 1, :discard)
    |> Enum.filter(fn [a, b] ->
      a == b
    end)
    |> Enum.group_by(& &1)
    |> Map.values()
    |> Enum.map(&length/1)
    |> (fn occurrences -> 1 in occurrences end).()
  end

  def two_adjacent_digits_same?(digits) do
    digits
    |> Stream.chunk_every(2, 1, :discard)
    |> Enum.any?(fn [a, b] ->
      a == b
    end)
  end

  def digits_decrease?(digits) do
    {_, decreasing?} =
      Enum.reduce_while(digits, {0, true}, fn d, {acc, _} ->
        if d - acc >= 0 do
          {:cont, {d, false}}
        else
          {:halt, {d, true}}
        end
      end)

    decreasing?
  end
end
