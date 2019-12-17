defmodule AOC.Day12.Moon do
  alias __MODULE__, as: T

  @type position :: {float, float, float}
  @type velocity :: {float, float, float}
  @type t :: %T{
          id: integer,
          position: position,
          velocity: velocity
        }

  defstruct [:id, :position, :velocity]

  @spec new(integer, position, velocity) :: t
  def new(id, position \\ {0, 0, 0}, velocity \\ {0, 0, 0}) do
    %T{id: id, position: position, velocity: velocity}
  end

  def update_position(moon, position) do
    %T{moon | :position => position}
  end

  def update_position_x(moon, pos) do
    {_x, y, z} = moon.position
    %T{moon | :position => {pos, y, z}}
  end

  def update_position_y(moon, pos) do
    {x, _y, z} = moon.position
    %T{moon | :position => {x, pos, z}}
  end

  def update_position_z(moon, pos) do
    {x, y, _z} = moon.position
    %T{moon | :position => {x, y, pos}}
  end

  def update_velocity(moon, velocity) do
    %T{moon | :velocity => velocity}
  end

  def update_velocity_x(moon, vel_x) do
    {_x, y, z} = moon.velocity
    %T{moon | :velocity => {vel_x, y, z}}
  end

  def update_velocity_y(moon, vel_y) do
    {x, _y, z} = moon.velocity
    %T{moon | :velocity => {x, vel_y, z}}
  end

  def update_velocity_z(moon, vel_z) do
    {x, y, _z} = moon.velocity
    %T{moon | :velocity => {x, y, vel_z}}
  end

  @spec total_energy(t) :: float
  def total_energy(moon) do
    potential_energy(moon) * kinetic_energy(moon)
  end

  @spec potential_energy(t) :: float
  def potential_energy(moon) do
    {x, y, z} = moon.position
    abs(x) + abs(y) + abs(z)
  end

  @spec kinetic_energy(t) :: float
  def kinetic_energy(moon) do
    {x, y, z} = moon.velocity
    abs(x) + abs(y) + abs(z)
  end

  def apply_gravity_to_velocity_axis({p1, v1}, {p2, v2}) do
    {delta_v1, delta_v2} =
      cond do
        p1 < p2 -> {+1, -1}
        p1 > p2 -> {-1, +1}
        p1 == p2 -> {0, 0}
      end

    {v1 + delta_v1, v2 + delta_v2}
  end

  def apply_velocity_to_position_axis({p1, v1}) do
    p1 + v1
  end

  def apply_gravity_to_velocity({m1, m2}) do
    {x1, y1, z1} = m1.position
    {x2, y2, z2} = m2.position

    {vel_x1, vel_y1, vel_z1} = m1.velocity
    {vel_x2, vel_y2, vel_z2} = m2.velocity

    {vel_x1, vel_x2} = apply_gravity_to_velocity_axis({x1, vel_x1}, {x2, vel_x2})
    {vel_y1, vel_y2} = apply_gravity_to_velocity_axis({y1, vel_y1}, {y2, vel_y2})
    {vel_z1, vel_z2} = apply_gravity_to_velocity_axis({z1, vel_z1}, {z2, vel_z2})

    m1_vel = {vel_x1, vel_y1, vel_z1}
    m2_vel = {vel_x2, vel_y2, vel_z2}

    m1 = update_velocity(m1, m1_vel)
    m2 = update_velocity(m2, m2_vel)
    {m1, m2}
  end

  def apply_velocity_to_position(moon) do
    {x1, y1, z1} = moon.position
    {x2, y2, z2} = moon.velocity

    x = apply_velocity_to_position_axis({x1, x2})
    y = apply_velocity_to_position_axis({y1, y2})
    z = apply_velocity_to_position_axis({z1, z2})

    moon = update_position(moon, {x, y, z})
  end
end

# defimpl Inspect, for: AOC.Day12.Moon do
#  def inspect(moon, _opts) do
#    "#{moon.id}, #{moon.position}, #{moon.velocity}"
#  end
# end
#
# defimpl String.Chars, for: AOC.Day12.Moon do
#  def to_string(moon) do
#    "#{moon.id}, #{moon.position}, #{moon.velocity}"
#  end
# end
