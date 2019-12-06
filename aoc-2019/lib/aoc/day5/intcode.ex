defmodule AOC.Day5.Intcode do
  @moduledoc false

  @type memory :: %{integer => integer}

  def part1(path) do
    stream_input(path)
    |> input_to_map()
    |> compute
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
    result =
      memory
      |> update(1, noun)
      |> update(2, verb)
      |> compute()

    cond do
      output == result -> {noun, verb}
      verb <= 99 -> brute_force(memory, output, noun, verb + 1)
      noun <= 99 -> brute_force(memory, output, noun + 1, 0)
      true -> :error
    end
  end

  @spec compute(memory) :: integer
  def compute(memory) do
    0..map_size(memory)
    |> Enum.reduce_while({memory, 0}, fn _i, {memory, instruction_pointer} ->
      with {parameter_modes, opcode} <- process_address(memory, instruction_pointer),
           {operation, num_params} <- instruction(memory, opcode),
           false <- is_atom(operation),
           params <- read_params(memory, instruction_pointer, num_params),
           params <- Enum.zip(params, parameter_modes),
           result <- apply(operation, [memory | params]),
           false <- is_atom(result) do
        {:cont, {result, instruction_pointer + num_params}}
      else
        _ ->
          IO.puts("Halting")
          {:halt, read(memory, 0)}
      end
    end)
  end

  def process_address(memory, address) do
    {parameter_modes, op} = read(memory, address)
                            |> Integer.digits()
                            |> Enum.split(-2)
    padding = Enum.take([0,0,0,0,0,0], 5 - length(parameter_modes))
    parameter_modes = Enum.reverse(parameter_modes) ++ padding
    op = Integer.undigits(op)
    {parameter_modes, op}
  end

  @spec read_params(memory, integer, integer) :: list(integer)
  def read_params(memory, instruction_pointer, num_params) do
    num_params = num_params - 2

    if num_params >= 0 do
      Enum.map(0..num_params, fn i -> read(memory, i + instruction_pointer + 1) end)
    else
      []
    end
  end

  @spec read(memory, integer) :: integer
  @spec read(memory, {integer, integer}) :: integer
  def read(memory, {address, mode}) do
    cond do
      mode == 0 -> read(memory, address)
      mode == 1 -> address
      true -> :error_read
    end
  end

  def read(memory, address) do
    Map.get(memory, address)
  end

  @spec update(memory, integer, integer) :: memory
  def update(memory, address, value) do
    %{memory | address => value}
  end

  @spec instruction(memory, integer) :: {(... -> memory) | :error, integer}
  def instruction(memory, opcode) do
    cond do
      opcode == 1 ->
        func = &add/4
        {:arity, num_params} = Function.info(func, :arity)
        {func, num_params}

      opcode == 2 ->
        func = &multiply/4
        {:arity, num_params} = Function.info(func, :arity)
        {func, num_params}

      opcode == 3 ->
        func = &input/2
        {:arity, num_params} = Function.info(func, :arity)
        {func, num_params}

      opcode == 4 ->
        func = &output/2
        {:arity, num_params} = Function.info(func, :arity)
        {func, num_params}

      opcode == 99 ->
        func = &terminate/1
        {:arity, num_params} = Function.info(func, :arity)
        {func, num_params}

      true ->
        :error
    end
  end

  @spec add(memory, integer, integer, integer) :: memory
  def add(memory, param1, param2, {param3, 0}) do
    value = read(memory, param1) + read(memory, param2)
    update(memory, param3, value)
  end

  @spec multiply(memory, integer, integer, integer) :: memory
  def multiply(memory, param1, param2, {param3, 0}) do
    value = read(memory, param1) * read(memory, param2)
    update(memory, param3, value)
  end

  @spec input(memory, integer) :: memory
  def input(memory, {param1, 0}) do
    {value, _} = IO.gets("Awaiting input:")
          |> Integer.parse()
    update(memory, param1, value)
  end

  @spec output(memory, integer) :: memory
  def output(memory, param1) do
    read(memory, param1)
    |> (&(IO.puts("Output: #{&1}"))).()

    memory
  end

  @spec terminate(memory) :: :terminate
  def terminate(_memory) do
    :terminate
  end
end
