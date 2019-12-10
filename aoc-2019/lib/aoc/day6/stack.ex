defmodule AOC.Day6.Stack do
  alias __MODULE__, as: T

  @moduledoc false

  @opaque t :: __MODULE__.t()

  defstruct list: []

  @spec new(list(any)) :: t
  def new(list \\ []) do
    %T{list: list}
  end

  @spec pop(t) :: {any, t}
  def pop(stack) do
    cond do
      empty?(stack) -> {nil, stack}
      length(stack.list) == 1 -> {hd(stack.list), new()}
      length(stack.list) > 1 -> {hd(stack.list), new(tl(stack.list))}
    end
  end

  @spec push(t, any) :: t
  def push(stack, element) do
    new([element | stack.list])
  end

  @spec empty?(t) :: boolean
  def empty?(stack) do
    stack.list == []
  end
end
