defmodule AOC.Day6.OrbitChecksum do
  alias AOC.Day6.Node
  alias AOC.Day6.Stack

  @moduledoc false

  def part1(path) do
    read_puzzle_input(path)
    |> process_input()
    |> child_to_parent_map()
    |> checksum()
  end

  def part2(path) do
    read_puzzle_input(path)
    |> process_input()
    |> neighbor_map()
    |> depth_first_search("YOU", "SAN")
    |> node_to_path()
    # Remove "YOU", "SAN", and the starting object
    |> (&(length(&1) - 3)).()
  end

  def read_puzzle_input(path) do
    File.read!(path)
  end

  def process_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
  end

  def child_to_parent_map(input) do
    Enum.reduce(input, %{}, fn val, objects ->
      [parent, child] = String.split(val, ")")
      Map.put(objects, child, parent)
    end)
  end

  @spec checksum(map()) :: integer
  def checksum(objects) do
    Enum.reduce(objects, 0, fn {key, _val}, acc ->
      walk(objects, key, acc)
    end)
  end

  @spec walk(map(), String.t(), integer) :: integer
  def walk(objects, start, acc \\ 0) do
    parent = Map.get(objects, start)

    if parent == nil do
      acc
    else
      walk(objects, parent, acc + 1)
    end
  end

  @spec neighbor_map(list(String.t())) :: map
  def neighbor_map(input) do
    Enum.reduce(input, %{}, fn val, objects ->
      [parent, child] = String.split(val, ")")

      parent_neighbors = Map.get(objects, parent)

      objects =
        if parent_neighbors == nil do
          Map.put(objects, parent, [child])
        else
          neighbors = [child | parent_neighbors]
          Map.put(objects, parent, neighbors)
        end

      child_neighbors = Map.get(objects, child)

      objects =
        if child_neighbors == nil do
          Map.put(objects, child, [parent])
        else
          neighbors = [parent | child_neighbors]
          Map.put(objects, child, neighbors)
        end

      objects
    end)
  end

  @spec depth_first_search(
          a,
          b,
          b
        ) :: Node.t()
        when a: any, b: any
  def depth_first_search(objects, initial, goal) do
    frontier =
      Stack.new()
      |> Stack.push(Node.new(initial, nil))

    explored =
      MapSet.new()
      |> MapSet.put(initial)

    goal_fn = fn location -> goal == location end
    successors_fn = fn objects, value -> Map.get(objects, value) end

    dfs(objects, frontier, explored, goal_fn, successors_fn)
  end

  @spec dfs(
          a,
          Stack.t(),
          MapSet.t(),
          (b -> boolean),
          (a, b -> list(b))
        ) :: Node.t()
        when a: any, b: any
  defp dfs(objects, frontier, explored, goal_fn, successors_fn) do
    if Stack.empty?(frontier) == false do
      {current_node, frontier} = Stack.pop(frontier)
      current_state = current_node.state

      if goal_fn.(current_state) do
        current_node
      else
        {frontier, explored} =
          Enum.reduce(
            successors_fn.(objects, current_state),
            {frontier, explored},
            fn child, {frontier, explored} ->
              if Enum.member?(explored, child) == true do
                {frontier, explored}
              else
                frontier = Stack.push(frontier, Node.new(child, current_node))
                explored = MapSet.put(explored, child)
                {frontier, explored}
              end
            end
          )

        dfs(objects, frontier, explored, goal_fn, successors_fn)
      end
    end
  end

  @spec node_to_path(Node.t()) :: list(Node.t())
  def node_to_path(n) when n == nil do
    []
  end

  def node_to_path(n) when n != nil do
    path = [n.state]
    node_to_path(n, path)
  end

  defp node_to_path(n, path) do
    if n.parent == nil do
      path
    else
      n = n.parent
      node_to_path(n, [n.state | path])
    end
  end
end
