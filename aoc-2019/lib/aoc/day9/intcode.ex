defmodule AOC.Day9.Intcode do
  @moduledoc false

  @type memory :: %{
          integer => integer,
          pointer: integer,
          relative_base: integer,
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
    |> (&Map.put(&1, :pointer, 0)).()
    |> (&Map.put(&1, :relative_base, 0)).()
    |> (&Map.put(&1, :inputs, user_input)).()
    |> (&Map.put(&1, :outputs, [])).()
  end

  @spec permutations(list) :: list(list)
  def permutations([]), do: [[]]

  def permutations(list) do
    for head <- list, tail <- permutations(list -- [head]) do
      tail ++ [head]
    end
    |> Enum.uniq()
  end

  @spec amplifiers(list(integer)) :: {list(integer), integer}
  def amplifiers(puzzle_input) do
    permutations([4, 3, 2, 1, 0])
    |> Enum.map(fn phase ->
      output_signal =
        Enum.reduce(phase, 0, fn phase_setting, previous_output ->
          memory = puzzle_input_to_map(puzzle_input, [phase_setting, previous_output])
          {_state, memory} = compute(memory)

          output_signal =
            Enum.reverse(read_outputs(memory))
            |> hd()

          output_signal
        end)

      {phase, output_signal}
    end)
    |> Enum.max_by(fn {_phase, output_signal} -> output_signal end)
  end

  @spec amplifiers_feedback(list(integer)) :: {list(integer), integer}
  def amplifiers_feedback(puzzle_input) do
    permutations([9, 8, 7, 6, 5])
    |> Enum.map(fn phase ->
      memories =
        Enum.map(phase, fn phase_setting ->
          puzzle_input_to_map(puzzle_input, [phase_setting])
        end)

      memory_map =
        %{}
        |> Map.put(:a, Enum.at(memories, 0))
        |> Map.put(:b, Enum.at(memories, 1))
        |> Map.put(:c, Enum.at(memories, 2))
        |> Map.put(:d, Enum.at(memories, 3))
        |> Map.put(:e, Enum.at(memories, 4))

      {_memory_map, output_signal} = do_amplifiers_feedback_loop(memory_map)

      {phase, output_signal}
    end)
    |> Enum.max_by(fn {_phase, output_signal} -> output_signal end)
  end

  defp do_amplifiers_feedback_loop(memory_map) do
    [:a, :b, :c, :d, :e]
    |> Stream.cycle()
    |> Enum.reduce_while({memory_map, 0}, fn amp, {memory_map, output_signal} ->
      memory = Map.get(memory_map, amp)
      memory = append_input(memory, output_signal)
      {state, memory} = compute(memory)

      output_signal =
        read_outputs(memory)
        |> hd()

      memory_map = Map.put(memory_map, amp, memory)

      if :waiting == state or (:terminate == state and :e != amp) do
        {:cont, {memory_map, output_signal}}
      else
        {:halt, {memory_map, output_signal}}
      end
    end)
  end

  @spec compute(memory) :: {:error | :waiting | :terminate, memory}
  def compute(memory) when is_map(memory) do
    Stream.cycle([-1])
    |> Enum.reduce_while({:continue, memory}, fn _i, {_state, memory} ->
      with {parameter_modes, opcode} <- process_address(memory),
           {operation, num_params} <- instruction(memory, opcode),
           params <- read_params(memory, num_params),
           params <- Enum.zip(params, parameter_modes),
           result <- apply(operation, [{memory, num_params} | params]),
           %{} <- result do
        {:cont, {:continue, result}}
      else
        :error ->
          {:halt, {:error, memory}}

        {:waiting, memory} ->
          {:halt, {:waiting, memory}}

        :terminate ->
          {:halt, {:terminate, memory}}
      end
    end)
  end

  @spec process_address(memory) :: {list(integer), integer}
  def process_address(memory) do
    address = read_instruction_pointer(memory)

    {parameter_modes, op} =
      read(memory, address)
      |> Integer.digits()
      |> Enum.split(-2)

    padding = Enum.take([0, 0, 0, 0, 0, 0], 5 - length(parameter_modes))
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

  @spec read(memory, {integer, integer}) :: integer
  def read(memory, {address, mode}) do
    cond do
      mode == 0 -> read(memory, address)
      mode == 1 -> address
      mode == 2 -> read(memory, address + read_relative_base(memory))
      true -> :error_read
    end
  end

  @spec read(memory, integer) :: integer
  def read(memory, address) do
    Map.get(memory, address, 0)
  end

  @spec read_instruction_pointer(memory) :: integer
  def read_instruction_pointer(memory) do
    memory.pointer
  end

  @spec update_instruction_pointer(memory, integer) :: memory
  def update_instruction_pointer(memory, value) do
    Map.put(memory, :pointer, value)
  end

  @spec increment_instruction_pointer(memory, integer) :: memory
  def increment_instruction_pointer(memory, value) do
    pointer = read_instruction_pointer(memory)
    update_instruction_pointer(memory, pointer + value)
  end

  @spec read_relative_base(memory) :: integer
  def read_relative_base(memory) do
    memory.relative_base
  end

  @spec update_relative_base(memory, integer) :: memory
  def update_relative_base(memory, value) do
    Map.put(memory, :relative_base, value + read_relative_base(memory))
  end

  @spec read_inputs(memory) :: list(integer)
  def read_inputs(memory) do
    memory.inputs
  end

  @spec insert_input_at(memory, integer, integer) :: memory
  def insert_input_at(memory, index, value) do
    inputs = List.insert_at(memory.inputs, index, value)
    Map.put(memory, :inputs, inputs)
  end

  @spec pop_input(memory) :: {integer | nil, memory}
  def pop_input(memory) do
    inputs = memory.inputs

    cond do
      Enum.empty?(inputs) ->
        {nil, memory}

      length(inputs) == 1 ->
        head = hd(memory.inputs)
        memory = Map.put(memory, :inputs, [])
        {head, memory}

      true ->
        [head | tail] = memory.inputs
        memory = Map.put(memory, :inputs, tail)
        {head, memory}
    end
  end

  @spec append_input(memory, integer) :: memory
  def append_input(memory, value) do
    inputs = memory.inputs
    Map.put(memory, :inputs, inputs ++ [value])
  end

  @spec read_outputs(memory) :: list(integer)
  def read_outputs(memory) do
    memory.outputs
  end

  @spec push_output(memory, integer) :: memory
  def push_output(memory, value) do
    outputs = memory.outputs
    Map.put(memory, :outputs, [value | outputs])
  end

  @spec update(memory, {integer, integer}, integer) :: memory
  def update(memory, {address, mode}, value) do
    case mode do
      0 -> Map.put(memory, address, value)
      2 -> Map.put(memory, address + read_relative_base(memory), value)
    end
  end

  @spec instruction(memory, integer) :: {(... -> memory), integer} | :error
  def instruction(_memory, opcode) do
    instructions = %{
      1 => &add/4,
      2 => &multiply/4,
      3 => &input/2,
      4 => &output/2,
      5 => &jump_if_true/3,
      6 => &jump_if_false/3,
      7 => &less_than/4,
      8 => &equals/4,
      9 => &relative_base/2,
      99 => &terminate/1
    }

    func = Map.get(instructions, opcode)

    if func == nil do
      :error
    else
      {:arity, num_params} = Function.info(func, :arity)
      {func, num_params}
    end
  end

  @spec add({memory, integer}, {integer, integer}, {integer, integer}, {integer, integer}) ::
          memory
  def add({memory, num_params}, param_and_mode1, param_and_mode2, param_and_mode3) do
    value = read(memory, param_and_mode1) + read(memory, param_and_mode2)

    update(memory, param_and_mode3, value)
    |> increment_instruction_pointer(num_params)
  end

  @spec multiply({memory, integer}, {integer, integer}, {integer, integer}, {integer, integer}) ::
          memory
  def multiply({memory, num_params}, param_and_mode1, param_and_mode2, param_and_mode3) do
    value = read(memory, param_and_mode1) * read(memory, param_and_mode2)

    update(memory, param_and_mode3, value)
    |> increment_instruction_pointer(num_params)
  end

  @spec input({memory, integer}, {integer, integer}) :: memory | {:waiting, memory}
  def input({memory, num_params}, param_and_mode1) do
    {value, memory} = pop_input(memory)

    if value != nil do
      update(memory, param_and_mode1, value)
      |> increment_instruction_pointer(num_params)
    else
      {:waiting, memory}
    end
  end

  @spec output({memory, integer}, {integer, integer}) :: {:waiting, memory}
  def output({memory, num_params}, param1) do
    value = read(memory, param1)

    memory =
      push_output(memory, value)
      |> increment_instruction_pointer(num_params)

    {:waiting, memory}
  end

  def jump_if_true({memory, num_params}, param_and_mode1, param_and_mode2) do
    v1 = read(memory, param_and_mode1)
    v2 = read(memory, param_and_mode2)

    if v1 != 0 do
      update_instruction_pointer(memory, v2)
    else
      increment_instruction_pointer(memory, num_params)
    end
  end

  def jump_if_false({memory, num_params}, param_and_mode1, param_and_mode2) do
    v1 = read(memory, param_and_mode1)
    v2 = read(memory, param_and_mode2)

    if v1 == 0 do
      update_instruction_pointer(memory, v2)
    else
      increment_instruction_pointer(memory, num_params)
    end
  end

  def less_than({memory, num_params}, param_and_mode1, param_and_mode2, param_and_mode3) do
    v1 = read(memory, param_and_mode1)
    v2 = read(memory, param_and_mode2)

    if v1 < v2 do
      update(memory, param_and_mode3, 1)
    else
      update(memory, param_and_mode3, 0)
    end
    |> increment_instruction_pointer(num_params)
  end

  def equals({memory, num_params}, param_and_mode1, param_and_mode2, param_and_mode3) do
    v1 = read(memory, param_and_mode1)
    v2 = read(memory, param_and_mode2)

    if v1 == v2 do
      update(memory, param_and_mode3, 1)
    else
      update(memory, param_and_mode3, 0)
    end
    |> increment_instruction_pointer(num_params)
  end

  def relative_base({memory, num_params}, param_and_mode1) do
    value = read(memory, param_and_mode1)

    update_relative_base(memory, value)
    |> increment_instruction_pointer(num_params)
  end

  @spec terminate(memory) :: :terminate
  def terminate(_memory) do
    :terminate
  end
end
