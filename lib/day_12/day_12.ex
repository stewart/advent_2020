defmodule Day12 do
  @moduledoc false

  parse = fn <<action, value::binary>> ->
    {action, String.to_integer(value)}
  end

  @data [__DIR__, "DATA"]
        |> Path.join()
        |> File.stream!()
        |> Stream.map(&String.trim/1)
        |> Enum.map(parse)

  defmodule Ship do
    defstruct [:pos, :h]

    alias __MODULE__

    def new, do: %Ship{h: 90, pos: {0, 0}}

    def abs_pos(%Ship{pos: {x, y}}), do: abs(x) + abs(y)

    def instruct({?N, v}, ship), do: move(ship, {0, v})
    def instruct({?S, v}, ship), do: move(ship, {0, -v})
    def instruct({?E, v}, ship), do: move(ship, {v, 0})
    def instruct({?W, v}, ship), do: move(ship, {-v, 0})
    def instruct({?F, v}, ship), do: move_forward(ship, v)
    def instruct({?R, v}, ship), do: adjust_heading(ship, v)
    def instruct({?L, v}, ship), do: adjust_heading(ship, -v)

    defp move(%Ship{pos: {x, y}} = ship, {dx, dy}), do: %Ship{ship | pos: {x + dx, y + dy}}

    defp move_forward(%Ship{h: h} = ship, v) when h <= 45 or h > 315, do: move(ship, {0, v})
    defp move_forward(%Ship{h: h} = ship, v) when h <= 135, do: move(ship, {v, 0})
    defp move_forward(%Ship{h: h} = ship, v) when h <= 225, do: move(ship, {0, -v})
    defp move_forward(%Ship{h: h} = ship, v) when h <= 315, do: move(ship, {-v, 0})

    defp adjust_heading(%Ship{h: h} = ship, v), do: %Ship{ship | h: Integer.mod(h + v, 360)}
  end

  defmodule Waypoint do
    defstruct [:pos, :h, :wp]

    def new, do: %__MODULE__{h: 90, pos: {0, 0}, wp: {10, 1}}

    def abs_pos(%__MODULE__{pos: {x, y}}), do: abs(x) + abs(y)

    def instruct({?N, v}, ship), do: move_wp(ship, {0, v})
    def instruct({?S, v}, ship), do: move_wp(ship, {0, -v})
    def instruct({?E, v}, ship), do: move_wp(ship, {v, 0})
    def instruct({?W, v}, ship), do: move_wp(ship, {-v, 0})
    def instruct({?F, v}, ship), do: move_ship(ship, v)
    def instruct({?R, v}, ship), do: adjust_wp_heading(ship, v)
    def instruct({?L, v}, ship), do: adjust_wp_heading(ship, 360 - v)

    defp move_wp(%__MODULE__{wp: {x, y}} = ship, {dx, dy}),
      do: %__MODULE__{ship | wp: {x + dx, y + dy}}

    defp move_ship(%__MODULE__{pos: {x, y}, wp: {wx, wy}} = ship, n),
      do: %__MODULE__{ship | pos: {x + n * wx, y + n * wy}}

    defp adjust_wp_heading(%__MODULE__{wp: {x, y}} = ship, 90),
      do: %__MODULE__{ship | wp: {y, -x}}

    defp adjust_wp_heading(%__MODULE__{wp: {x, y}} = ship, 180),
      do: %__MODULE__{ship | wp: {-x, -y}}

    defp adjust_wp_heading(%__MODULE__{wp: {x, y}} = ship, 270),
      do: %__MODULE__{ship | wp: {-y, x}}
  end

  def data do
    @data
  end

  def part1 do
    ship = Enum.reduce(data(), Ship.new(), &Ship.instruct/2)
    Ship.abs_pos(ship)
  end

  def part2 do
    waypoint = Enum.reduce(data(), Waypoint.new(), &Waypoint.instruct/2)
    Waypoint.abs_pos(waypoint)
  end
end
