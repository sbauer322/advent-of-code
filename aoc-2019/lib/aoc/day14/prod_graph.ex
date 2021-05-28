defmodule AOC.Day14.ProdGraph do
  alias __MODULE__, as: T

  @type t :: %T{
          name: String.t(),
          quantity_produced: integer,
          required: list(t)
        }

  defstruct [:name, :quantity_produced, :required]

  @spec new(String.t(), integer, list(t)) :: t
  def new(name, quantity_produced, required) do
    %T{name: name, quantity_produced: quantity_produced, required: required}
  end
end
