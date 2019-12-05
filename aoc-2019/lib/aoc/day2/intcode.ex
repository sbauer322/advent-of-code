defmodule AOC.Day2.Intcode do

  @type memory :: %{integer => integer}

  def part1(path) do
    stream_input(path)
    |> input_to_map()
    |> update(1, 12)
    |> update(2, 2)
    |> compute
  end

  def part2(path, output) do
    {noun, verb} = stream_input(path)
    |> input_to_map()
    |> brute_force(output, 0, 0)

    100 * noun + verb
  end

  def stream_input(path) do
    File.read!(path)
    |> String.trim()
    |> String.split(",")
  end

  @spec input_to_map(list(integer)) :: memory
  def input_to_map(input) do
    input
    |> Stream.with_index()
    |> Stream.map(fn {value, index} ->
      {index, String.to_integer(value)}
    end)
    |> Map.new()
  end

  @spec brute_force(memory, integer, integer, integer) :: {integer, integer} | :error
  defp brute_force(memory, output, noun, verb) do
    result = memory
             |> update(1, noun)
             |> update(2, verb)
             |> compute()

    cond do
      output == result -> {noun, verb}
      verb <= 99 -> brute_force(memory, output, noun, verb+1)
      noun <= 99 -> brute_force(memory, output, noun+1, 0)
      true -> :error
    end
  end

  @spec compute(memory) :: integer
  def compute(program) do
    0..map_size(program)
    |> Enum.reduce_while({program, 0}, fn _i, {memory, instruction_pointer} ->
      with {op, num_params} <- instruction(memory, instruction_pointer),
           false <- is_atom(op),
           params <- read_params(memory, instruction_pointer, num_params),
           result <- apply(op, [memory | params]),
           false <- is_atom(result)
        do
          {:cont, {result, instruction_pointer + num_params}}
        else
          _ -> {:halt, read(memory, 0)}
      end
    end)
  end

  @spec read_params(memory, integer, integer) :: list(integer)
  def read_params(memory, instruction_pointer, num_params) do
    num_params = num_params - 2
    if (num_params > 0) do
      Enum.map(0..num_params, fn i -> read(memory, i + instruction_pointer + 1) end)
    else
      []
    end
  end

  @spec read(memory, integer) :: integer
  def read(memory, address) do
    Map.get(memory, address)
  end

  @spec update(memory, integer, integer) :: memory
  def update(memory, address, value) do
    %{memory | address => value}
  end

  @spec instruction(memory, integer) :: {(... -> memory) | :error, integer}
  def instruction(memory, instruction_pointer) do
    opcode = read(memory, instruction_pointer)
    cond do
      opcode == 1 ->
        func = &add/4
        {:arity, num_params} = Function.info(func, :arity)
        {func, num_params}
      opcode == 2 ->
         func = &multiply/4
         {:arity, num_params} = Function.info(func, :arity)
         {func, num_params}
      opcode == 99 ->
        func = &terminate/1
        {:arity, num_params} = Function.info(func, :arity)
        {func, num_params}
      true -> :error
    end
  end

  @spec add(memory, integer, integer, integer) :: memory
  def add(memory, param1, param2, param3) do
    value = read(memory, param1) + read(memory, param2)
    update(memory, param3, value)
  end

  @spec multiply(memory, integer, integer, integer) :: memory
  def multiply(memory, param1, param2, param3) do
    value = read(memory, param1) * read(memory, param2)
    update(memory, param3, value)
  end

  @spec terminate(memory) :: :terminate
  def terminate(_memory) do
    :terminate
  end

end