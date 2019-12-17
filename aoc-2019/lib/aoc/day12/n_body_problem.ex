defmodule AOC.Day12.NBodyProblem do
  alias AOC.Day12.Moon

  @moduledoc """
  Think of it like multivariable analysis... hold others constant and change only one.
  Hint from `https://www.reddit.com/r/adventofcode/comments/e9jxh2/help_2019_day_12_part_2_what_am_i_not_seeing/`
  """

  def part1(input, timesteps) do
    process_input(input)
    |> step(timesteps)
  end

  def part2(input) do
    process_input(input)
    |> compute_steps_to_repeat
  end

  def read_input(path) do
    File.read!(path)
  end

  def process_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.map(fn {raw_moon, i} ->
      [x, y, z] =
        String.replace(raw_moon, ",", "")
        |> String.replace(~r/[><xyz=]/, "")
        |> String.trim()
        |> String.split(" ")
        |> Enum.map(&String.to_integer/1)

      Moon.new(i, {x, y, z}, {0, 0, 0})
    end)
    |> Map.new(fn moon -> {moon.id, moon} end)
  end

  def step(moons, max_timestep) do
    Enum.reduce(1..max_timestep, moons, fn i, moons ->
      moons
      |> step_velocities()
      |> step_positions()
    end)
  end

  def step_velocities(moons) do
    moon_pairs = all_pairs(Map.keys(moons))

    Enum.reduce(moon_pairs, moons, fn {i, j}, moons ->
      a = Map.get(moons, i)
      b = Map.get(moons, j)
      {a, b} = Moon.apply_gravity_to_velocity({a, b})

      moons =
        moons
        |> Map.put(i, a)
        |> Map.put(j, b)
    end)
  end

  def step_positions(moons) do
    Enum.reduce(moons, moons, fn {key, moon}, moons ->
      moon = Moon.apply_velocity_to_position(moon)
      Map.put(moons, key, moon)
    end)
  end

  def all_pairs(moons) do
    moons
    |> Enum.with_index()
    |> Enum.flat_map(fn {m, i} ->
      moons
      |> Enum.slice(0..i)
      |> Enum.map(fn w ->
        {w, m}
      end)
    end)
    |> Enum.filter(fn {a, b} ->
      a != b
    end)
  end

  def sum_total_energy(moons) do
    Enum.reduce(moons, 0, fn {key, moon}, sum ->
      sum + Moon.total_energy(moon)
    end)
  end

  def compute_steps_to_repeat(moons) do
    moon_pairs = all_pairs(Map.keys(moons))
    {a, x_step} = compute_x(moons, moon_pairs, moons, 0)
    {b, y_step} = compute_y(moons, moon_pairs, moons, 0)
    {c, z_step} = compute_z(moons, moon_pairs, moons, 0)

    lcm([x_step, y_step, z_step])
  end

  def compute_x(moons, moon_pairs, initial_moons, current_step) do
    moons =
      Enum.reduce(moon_pairs, moons, fn {i, j}, moons ->
        m1 = Map.get(moons, i)
        m2 = Map.get(moons, j)
        {p1, _, _} = m1.position
        {v1, _, _} = m1.velocity
        {p2, _, _} = m2.position
        {v2, _, _} = m2.velocity
        {m1_v, m2_v} = Moon.apply_gravity_to_velocity_axis({p1, v1}, {p2, v2})
        m1 = Moon.update_velocity_x(m1, m1_v)
        m2 = Moon.update_velocity_x(m2, m2_v)

        moons =
          moons
          |> Map.put(i, m1)
          |> Map.put(j, m2)
      end)

    moons =
      Enum.reduce(moons, moons, fn {key, moon}, moons ->
        {p, _, _} = moon.position
        {v, _, _} = moon.velocity
        p = Moon.apply_velocity_to_position_axis({p, v})
        moon = Moon.update_position_x(moon, p)
        Map.put(moons, key, moon)
      end)

    match =
      Enum.all?(moons, fn {key, moon} ->
        {p, _, _} = moon.position
        {v, _, _} = moon.velocity

        initial = Map.get(initial_moons, key)
        {initial_p, _, _} = initial.position
        {initial_v, _, _} = initial.velocity
        p == initial_p and v == initial_v
      end)

    if match do
      {moons, current_step + 1}
    else
      compute_x(moons, moon_pairs, initial_moons, current_step + 1)
    end
  end

  def compute_y(moons, moon_pairs, initial_moons, current_step) do
    moons =
      Enum.reduce(moon_pairs, moons, fn {i, j}, moons ->
        m1 = Map.get(moons, i)
        m2 = Map.get(moons, j)
        {_, p1, _} = m1.position
        {_, v1, _} = m1.velocity
        {_, p2, _} = m2.position
        {_, v2, _} = m2.velocity
        {m1_v, m2_v} = Moon.apply_gravity_to_velocity_axis({p1, v1}, {p2, v2})
        m1 = Moon.update_velocity_y(m1, m1_v)
        m2 = Moon.update_velocity_y(m2, m2_v)

        moons =
          moons
          |> Map.put(i, m1)
          |> Map.put(j, m2)
      end)

    moons =
      Enum.reduce(moons, moons, fn {key, moon}, moons ->
        {_, p, _} = moon.position
        {_, v, _} = moon.velocity
        p = Moon.apply_velocity_to_position_axis({p, v})
        moon = Moon.update_position_y(moon, p)
        Map.put(moons, key, moon)
      end)

    match =
      Enum.all?(moons, fn {key, moon} ->
        {_, p, _} = moon.position
        {_, v, _} = moon.velocity

        initial = Map.get(initial_moons, key)
        {_, initial_p, _} = initial.position
        {_, initial_v, _} = initial.velocity
        p == initial_p and v == initial_v
      end)

    if match do
      {moons, current_step + 1}
    else
      compute_y(moons, moon_pairs, initial_moons, current_step + 1)
    end
  end

  def compute_z(moons, moon_pairs, initial_moons, current_step) do
    moons =
      Enum.reduce(moon_pairs, moons, fn {i, j}, moons ->
        m1 = Map.get(moons, i)
        m2 = Map.get(moons, j)
        {_, _, p1} = m1.position
        {_, _, v1} = m1.velocity
        {_, _, p2} = m2.position
        {_, _, v2} = m2.velocity
        {m1_v, m2_v} = Moon.apply_gravity_to_velocity_axis({p1, v1}, {p2, v2})
        m1 = Moon.update_velocity_z(m1, m1_v)
        m2 = Moon.update_velocity_z(m2, m2_v)

        moons =
          moons
          |> Map.put(i, m1)
          |> Map.put(j, m2)
      end)

    moons =
      Enum.reduce(moons, moons, fn {key, moon}, moons ->
        {_, _, p} = moon.position
        {_, _, v} = moon.velocity
        p = Moon.apply_velocity_to_position_axis({p, v})
        moon = Moon.update_position_z(moon, p)
        Map.put(moons, key, moon)
      end)

    match =
      Enum.all?(moons, fn {key, moon} ->
        {_, _, p} = moon.position
        {_, _, v} = moon.velocity

        initial = Map.get(initial_moons, key)
        {_, _, initial_p} = initial.position
        {_, _, initial_v} = initial.velocity
        p == initial_p and v == initial_v
      end)

    if match do
      {moons, current_step + 1}
    else
      compute_z(moons, moon_pairs, initial_moons, current_step + 1)
    end
  end

  def gcd(a, 0) do
    a
  end

  def gcd(0, b) do
    b
  end

  def gcd(a, b) do
    gcd(b, rem(trunc(a), trunc(b)))
  end

  def lcm(0, 0) do
    0
  end

  def lcm(a, b) do
    div(a * b, gcd(a, b))
  end

  def lcm(list) do
    [a, b | tail] = list
    initial = lcm(a, b)

    Enum.reduce(tail, initial, fn x, acc ->
      lcm(acc, x)
    end)
  end
end
