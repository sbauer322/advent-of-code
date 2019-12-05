defmodule AOC.Day4.SecureContainerTest do
  alias AOC.Day4.SecureContainer

  use ExUnit.Case

  @moduledoc false

  test "bounds checking" do
    value1 = 111_111
    value2 = 223_450
    value3 = 123_789
    value4 = 675_810

    assert false == SecureContainer.in_bounds?(value1)
    assert true == SecureContainer.in_bounds?(value2)
    assert false == SecureContainer.in_bounds?(value3)
    assert true == SecureContainer.in_bounds?(value4)
  end

  test "distinct two adjacent digits" do
    digits1 = Integer.digits(112_233)
    digits2 = Integer.digits(123_444)
    digits3 = Integer.digits(111_122)

    assert true == SecureContainer.distinct_two_adjacent_digits?(digits1)
    assert false == SecureContainer.distinct_two_adjacent_digits?(digits2)
    assert true == SecureContainer.distinct_two_adjacent_digits?(digits3)
  end

  test "two adjacent digits" do
    digits1 = Integer.digits(111_111)
    digits2 = Integer.digits(223_450)
    digits3 = Integer.digits(123_789)

    assert true == SecureContainer.two_adjacent_digits_same?(digits1)
    assert true == SecureContainer.two_adjacent_digits_same?(digits2)
    assert false == SecureContainer.two_adjacent_digits_same?(digits3)
  end

  test "never decreases" do
    digits1 = Integer.digits(111_111)
    digits2 = Integer.digits(223_450)
    digits3 = Integer.digits(123_789)

    assert false == SecureContainer.digits_decrease?(digits1)
    assert true == SecureContainer.digits_decrease?(digits2)
    assert false == SecureContainer.digits_decrease?(digits3)
  end

  test "part 1" do
    assert 1955 == SecureContainer.part1()
  end

  test "part 2" do
    assert 1319 == SecureContainer.part2()
  end
end
