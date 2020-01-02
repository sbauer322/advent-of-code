defmodule AOC.Day14.SpaceStoichiometry do
  @moduledoc false

  def part1(requirement_map) do
    calculate_chemicals(requirement_map, {1, "FUEL"})
    |> calculate_ore_cost(requirement_map)
  end

  @spec process_input(String.t()) :: %{String.t() => {integer, list({integer, String.t()})}}
  def process_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.reduce(%{}, fn row, acc ->
      row
      |> String.split(~r/=>|,/)
      |> Enum.map(fn pairs ->
        process_pairs(pairs)
      end)
      |> (fn row ->
            [{quantity, chemical} | tail] = Enum.reverse(row)
            Map.put(acc, chemical, {quantity, tail})
          end).()
    end)
  end

  def process_pairs(pairs) do
    pairs
    |> String.trim()
    |> String.split(" ")
    |> (fn [quantity, chemical] ->
          quantity = String.to_integer(quantity)
          {quantity, chemical}
        end).()
  end

def calculate_chemicals(requirement_map, {quantity, chemical}) do
    {quantity_produced, required} = Map.get(requirement_map, chemical, {nil, [nil]})
    needs_ore = Enum.at(required, 0) |> (&(elem(&1, 1) == "ORE")).()

    if required == [nil] or needs_ore do
      {quantity, chemical}
    else
      required
#      |> Enum.sort_by(fn chemical ->
        # number or steps to "ORE"... higher distance goes first
#      end)
      |> Enum.map(fn chemical ->
        Enum.map(1..quantity, fn _i ->
          calculate_chemicals(requirement_map, chemical)
        end)
      end)
      #      Enum.map(required, fn chemical ->
      #        calculate_chemicals(requirement_map, chemical)
      #        end)
      |> List.flatten()
    end
  end

  def calculate_ore_cost(chemicals, requirements_map) do
    Enum.group_by(chemicals, fn {_quantity, chem} -> chem end, fn {quantity, _chem} ->
      quantity
    end)
    |> IO.inspect
    |> Enum.reduce(0, fn {chem, costs}, sum ->
      costs = Enum.sum(costs)
      {quantity_produced, [{ore_quantity, "ORE"}]} = Map.get(requirements_map, chem)
      :math.ceil(costs / quantity_produced) * ore_quantity + sum
    end)
  end

#  def gather_resources(requirement_map, stockpile, {quantity_needed, chemical}, total \\ 0) do
#    if (quantity_needed > 0) do
#      {stockpile, remaining_needed} = pull_from_stockpile(stockpile, {quantity_needed, chemical})
#      total = total + quantity_needed - remaining_needed
#      {quantity_produced, required} = Map.get(requirement_map, chemical, {nil, [nil]})
#
#      unused = quantity_produced - remaining_needed
#      total = total + quantity_produced - unused
#      if (unused > 0) do
#        stockpile = Map.put(stockpile, chemical, unused)
#        {stockpile, total, required}
#      else
#        gather_resources(requirement_map, stockpile, {abs(unused), chemical}, total)
#      end
#    else
#      {stockpile, total, chemical}
#    end
#  end
#
#  def pull_from_stockpile(stockpile, {quantity_needed, chemical}) do
#    # pull chemicals from stockpile first
#    # update stockpile with remainder, if any is left
#    # return stockpile and remaining amount needed
#    {quantity_in_stockpile, required} =  Map.get(stockpile, chemical, {0, nil})
#    remaining_in_stockpile = quantity_in_stockpile - quantity_needed
#    if (remaining_in_stockpile <= 0) do
#      stockpile = Map.put(stockpile, chemical, 0)
#      {stockpile, quantity_needed - quantity_in_stockpile}
#    else
#      stockpile = Map.put(stockpile, chemical, remaining_in_stockpile)
#      {stockpile, 0}
#    end
#  end
end
