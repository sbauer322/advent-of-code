defmodule AOC.Day6.Node do
  alias __MODULE__, as: T

  @moduledoc false

  @type t :: __MODULE__.t()

  defstruct state: nil, parent: nil, cost: 0.0, heuristic: 0.0

  @spec new(any, t | nil, float, float) :: t
  def new(state, parent, cost \\ 0.0, heuristic \\ 0.0) do
    %T{state: state, parent: parent, cost: cost, heuristic: heuristic}
  end

  @spec total_cost(t, t) :: boolean
  def total_cost(left, right) do
    left.cost + left.heuristic < right.cost + right.heuristic
  end
end
