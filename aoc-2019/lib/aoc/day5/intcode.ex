defmodule AOC.Day5.Intcode do
  @moduledoc false

  @type memory :: %{
                    integer => integer,
                    pointer: integer,
                    inputs: list(integer),
                    outputs: list(integer)
                  }

  def part1(path, user_inputs) do
    stream_puzzle_input(path)
    |> puzzle_input_to_map(user_inputs)
    |> compute
  end

  def part2(path, user_inputs) do
    stream_puzzle_input(path)
    |> puzzle_input_to_map(user_inputs)
    |> compute
  end

  def stream_puzzle_input(path) do
    File.read!(path)
    |> String.trim()
    |> String.split(",")
  end

  @spec puzzle_input_to_map(list(integer), list(integer)) :: memory
  def puzzle_input_to_map(puzzle_input, user_input \\ []) do
    puzzle_input
    |> Stream.with_index()
    |> Stream.map(fn {value, index} ->
      {index, String.to_integer(value)}
    end)
    |> Map.new()
    |> (&(Map.put(&1, :pointer, 0))).()
    |> (&(Map.put(&1, :inputs, user_input))).()
    |> (&(Map.put(&1, :outputs, []))).()
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

  @spec compute(memory) :: list(integer)
  def compute(memory) do
    0..map_size(memory)
    |> Enum.reduce_while(memory, fn _i, memory ->
      with {parameter_modes, opcode} <- process_address(memory),
           {operation, num_params} <- instruction(memory, opcode),
           false <- is_atom(operation),
           params <- read_params(memory, num_params),
           params <- Enum.zip(params, parameter_modes),
           result <- apply(operation, [{memory, num_params} | params]),
           false <- is_atom(result) do
        {:cont, result}
      else
        _ ->
          {:halt, Enum.reverse(read_outputs(memory))}
      end
    end)
  end

  def process_address(memory) do
    address = read_instruction_pointer(memory)
    {parameter_modes, op} = read(memory, address)
                            |> Integer.digits()
                            |> Enum.split(-2)
    padding = Enum.take([0,0,0,0,0,0], 5 - length(parameter_modes))
    parameter_modes = Enum.reverse(parameter_modes) ++ padding
    op = Integer.undigits(op)
    {parameter_modes, op}
  end

  @spec read_params(memory, integer) :: list(integer)
  def read_params(memory, num_params) do
    address = read_instruction_pointer(memory)
    num_params = num_params - 2

    if num_params >= 0 do
      Enum.map(0..num_params, fn i -> read(memory, i + address + 1) end)
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

  @spec read_instruction_pointer(memory) :: integer
  def read_instruction_pointer(memory) do
    memory.pointer
  end

  @spec update_instruction_pointer(memory, integer) :: memory
  def update_instruction_pointer(memory, value) do
    %{memory | :pointer => value}
  end

  @spec increment_instruction_pointer(memory, integer) :: memory
  def increment_instruction_pointer(memory, value) do
    pointer = read_instruction_pointer(memory)
    update_instruction_pointer(memory, pointer + value)
  end

  @spec pop_input(memory) :: {integer, memory}
  def pop_input(memory) do
    [head | tail] = memory.inputs
    memory = %{memory | :inputs => tail}
    {head, memory}
  end

  @spec append_input(memory, integer) :: memory
  def append_input(memory, value) do
    inputs = memory.inputs
    %{memory | :inputs => inputs ++ [value]}
  end

  @spec read_outputs(memory) :: list(integer)
  def read_outputs(memory) do
    memory.outputs
  end

  @spec push_output(memory, integer) :: memory
  def push_output(memory, value) do
    outputs = memory.outputs
    %{memory | :outputs => [value | outputs]}
  end

  @spec update(memory, integer, integer) :: memory
  def update(memory, address, value) do
    %{memory | address => value}
  end

  @spec instruction(memory, integer) :: {(... -> memory) | :error, integer}
  def instruction(_memory, opcode) do
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

      opcode == 5 ->
        func = &jump_if_true/3
        {:arity, num_params} = Function.info(func, :arity)
        {func, num_params}

      opcode == 6 ->
        func = &jump_if_false/3
        {:arity, num_params} = Function.info(func, :arity)
        {func, num_params}

      opcode == 7 ->
        func = &less_than/4
        {:arity, num_params} = Function.info(func, :arity)
        {func, num_params}

      opcode == 8 ->
        func = &equals/4
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

  @spec add({memory, integer}, {integer, integer}, {integer, integer}, {integer, integer}) :: memory
  def add({memory, num_params}, param_and_mode1, param_and_mode2, {param3, 0}) do
    value = read(memory, param_and_mode1) + read(memory, param_and_mode2)
    update(memory, param3, value)
    |> increment_instruction_pointer(num_params)
  end

  @spec multiply({memory, integer}, {integer, integer}, {integer, integer}, {integer, integer}) :: memory
  def multiply({memory, num_params}, param_and_mode1, param_and_mode2, {param3, 0}) do
    value = read(memory, param_and_mode1) * read(memory, param_and_mode2)
    update(memory, param3, value)
    |> increment_instruction_pointer(num_params)
  end

  @spec input({memory, integer}, {integer, integer}) :: memory
  def input({memory, num_params}, {param1, 0}) do
    {value, memory} = pop_input(memory)
    update(memory, param1, value)
    |> increment_instruction_pointer(num_params)
  end

  @spec output({memory, integer}, {integer, integer}) :: memory
  def output({memory, num_params}, param1) do
    read(memory, param1)
  #    |> (&(IO.puts("Output: #{&1}"))).()
    |> (&(push_output(memory, &1))).()
    |> increment_instruction_pointer(num_params)
  end

  def jump_if_true({memory, num_params}, param_and_mode1, param_and_mode2) do
    v1 = read(memory, param_and_mode1)
    v2 = read(memory, param_and_mode2)

    if (v1 != 0) do
      update_instruction_pointer(memory, v2)
    else
      increment_instruction_pointer(memory, num_params)
    end
  end

  def jump_if_false({memory, num_params}, param_and_mode1, param_and_mode2) do
    v1 = read(memory, param_and_mode1)
    v2 = read(memory, param_and_mode2)

    if (v1 == 0) do
      update_instruction_pointer(memory, v2)
    else
      increment_instruction_pointer(memory, num_params)
    end
  end

  def less_than({memory, num_params}, param_and_mode1, param_and_mode2, {param3, 0}) do
    v1 = read(memory, param_and_mode1)
    v2 = read(memory, param_and_mode2)

    if (v1 < v2) do
      update(memory, param3, 1)
    else
      update(memory, param3, 0)
    end
    |> increment_instruction_pointer(num_params)
  end

  def equals({memory, num_params}, param_and_mode1, param_and_mode2, {param3, 0}) do
    v1 = read(memory, param_and_mode1)
    v2 = read(memory, param_and_mode2)

    if (v1 == v2) do
      update(memory, param3, 1)
    else
      update(memory, param3, 0)
    end
    |> increment_instruction_pointer(num_params)
  end

  @spec terminate(memory) :: :terminate
  def terminate(_memory) do
    :terminate
  end
end
