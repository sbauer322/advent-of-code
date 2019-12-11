defmodule AOC.Day8.ImageFormatTest do
  alias AOC.Day8.ImageFormat

  use ExUnit.Case

  @moduledoc false

  test "checksum for 3 wide by 2 tall image" do
    input = "123456789012"

    result =
      ImageFormat.process_input(input)
      |> ImageFormat.chunk(3, 2)
      |> ImageFormat.image_checksum()

    assert 1 == result
  end

  test "render 2 wide by 2 high image" do
    input = "0222112222120000"

    result =
      ImageFormat.process_input(input)
      |> ImageFormat.decode_image(2, 2)

    assert ["0", "1", "1", "0"] == result
  end

  test "part 1" do
    result = ImageFormat.part1("./resources/day8_part1_input.txt")
    assert 2562 == result
  end

  test "part 2" do
    expected = [
      [
        "1",
        "1",
        "1",
        "1",
        "0",
        "1",
        "1",
        "1",
        "1",
        "0",
        "1",
        "0",
        "0",
        "0",
        "0",
        "1",
        "1",
        "1",
        "0",
        "0",
        "1",
        "0",
        "0",
        "0",
        "1"
      ],
      [
        "0",
        "0",
        "0",
        "1",
        "0",
        "1",
        "0",
        "0",
        "0",
        "0",
        "1",
        "0",
        "0",
        "0",
        "0",
        "1",
        "0",
        "0",
        "1",
        "0",
        "1",
        "0",
        "0",
        "0",
        "1"
      ],
      [
        "0",
        "0",
        "1",
        "0",
        "0",
        "1",
        "1",
        "1",
        "0",
        "0",
        "1",
        "0",
        "0",
        "0",
        "0",
        "1",
        "1",
        "1",
        "0",
        "0",
        "0",
        "1",
        "0",
        "1",
        "0"
      ],
      [
        "0",
        "1",
        "0",
        "0",
        "0",
        "1",
        "0",
        "0",
        "0",
        "0",
        "1",
        "0",
        "0",
        "0",
        "0",
        "1",
        "0",
        "0",
        "1",
        "0",
        "0",
        "0",
        "1",
        "0",
        "0"
      ],
      [
        "1",
        "0",
        "0",
        "0",
        "0",
        "1",
        "0",
        "0",
        "0",
        "0",
        "1",
        "0",
        "0",
        "0",
        "0",
        "1",
        "0",
        "0",
        "1",
        "0",
        "0",
        "0",
        "1",
        "0",
        "0"
      ],
      [
        "1",
        "1",
        "1",
        "1",
        "0",
        "1",
        "0",
        "0",
        "0",
        "0",
        "1",
        "1",
        "1",
        "1",
        "0",
        "1",
        "1",
        "1",
        "0",
        "0",
        "0",
        "0",
        "1",
        "0",
        "0"
      ]
    ]

    result = ImageFormat.part2("./resources/day8_part1_input.txt")
    # Spells 'ZFLBY'
    assert expected == result
  end
end
