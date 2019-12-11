defmodule AOC.Day8.ImageFormat do
  @moduledoc false

  def part1(path) do
    read_puzzle_input(path)
    |> process_input
    |> chunk(25, 6)
    |> image_checksum
  end

  def part2(path) do
    read_puzzle_input(path)
    |> process_input
    |> decode_image(25, 6)
    |> Enum.chunk_every(25)
  end

  def read_puzzle_input(path) do
    File.read!(path)
  end

  def process_input(input) do
    input
    |> String.trim()
    |> String.graphemes()
  end

  @spec chunk(list(String.t()), integer, integer) :: list(list(String.t()))
  def chunk(list, width, height) do
    list
    |> Enum.chunk_every(width)
    |> Enum.chunk_every(height)
  end

  @spec image_checksum(list(list(String.t()))) :: integer
  def image_checksum(layers) do
    Enum.map(layers, fn layer ->
      count_layer(layer)
    end)
    |> Enum.min_by(fn {zeros, _ones, _twos} ->
      zeros
    end)
    |> (fn {_zeros, ones, twos} -> ones * twos end).()
  end

  @spec count_layer(list(String.t())) :: {integer, integer, integer}
  def count_layer(layer) do
    Enum.reduce(layer, {0, 0, 0}, fn row, {zeros, ones, twos} ->
      {a, b, c} = count_digits(row)
      {zeros + a, ones + b, twos + c}
    end)
  end

  @spec count_digits(list(String.t())) :: {integer, integer, integer}
  def count_digits(list) do
    Enum.reduce(list, {0, 0, 0}, fn
      "0", {zeros, ones, twos} -> {zeros + 1, ones, twos}
      "1", {zeros, ones, twos} -> {zeros, ones + 1, twos}
      "2", {zeros, ones, twos} -> {zeros, ones, twos + 1}
      _, acc -> acc
    end)
  end

  @spec decode_image(list(String.t()), integer, integer) :: list(list(String.t()))
  def decode_image(list, width, height) do
    step = width * height
    layers = Enum.chunk_every(list, step)

    Enum.map(0..(step - 1), fn index ->
      find_pixel(layers, index)
    end)
  end

  def find_pixel(layers, index) do
    Enum.reduce_while(layers, 2, fn layer, _acc ->
      pixel = Enum.at(layer, index)

      if pixel == "2" do
        {:cont, pixel}
      else
        {:halt, pixel}
      end
    end)
  end
end
