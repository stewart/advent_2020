defmodule Day13 do
  @moduledoc false

  @timestamp 1_000_066
  @buses [
    13,
    nil,
    nil,
    41,
    nil,
    nil,
    nil,
    37,
    nil,
    nil,
    nil,
    nil,
    nil,
    659,
    nil,
    nil,
    nil,
    nil,
    nil,
    nil,
    nil,
    nil,
    nil,
    nil,
    nil,
    nil,
    nil,
    nil,
    nil,
    nil,
    nil,
    nil,
    19,
    nil,
    nil,
    nil,
    23,
    nil,
    nil,
    nil,
    nil,
    nil,
    29,
    nil,
    409,
    nil,
    nil,
    nil,
    nil,
    nil,
    nil,
    nil,
    nil,
    nil,
    nil,
    nil,
    nil,
    nil,
    nil,
    nil,
    nil,
    17
  ]

  def data do
    {@timestamp, @buses}
  end

  # ID of the earliest bus you can take to the airport
  # multiplied by how many minutes you'll wait for it
  def part1 do
    {timestamp, buses} = data()
    next_bus = buses |> in_service() |> find_next_bus(timestamp)
    next_bus * time_to_wait(timestamp, next_bus)
  end

  defp in_service(buses), do: Enum.filter(buses, & &1)
  defp find_next_bus(buses, timestamp), do: Enum.min_by(buses, &(&1 - rem(timestamp, &1)))
  defp time_to_wait(timestamp, next_bus), do: next_bus - rem(timestamp, next_bus)

  # find earliest timestamp at which all buses leave in ID sequence
  def part2 do
    {_, buses} = data()

    active = for {bus, idx} when not is_nil(bus) <- Stream.with_index(buses), do: {bus, idx}

    merge = fn {xp, xo}, {yp, yo} ->
      {gcd, s, _} = gcd_ext(xp, yp)
      period = lcm(xp, yp)
      offset = rem(-div(xo - yo, gcd) * s * xp + xo, period)
      {period, rem(offset, period)}
    end

    case Enum.reduce(active, merge) do
      {_, o} when o < 0 -> abs(o)
      {p, o} -> p - o
    end
  end

  def lcm(x, y), do: div(abs(x * y), Integer.gcd(x, y))

  def gcd_ext(x, 0), do: {x, 1, 0}
  def gcd_ext(0, y), do: {y, 0, 1}

  def gcd_ext(x, y) do
    {g, s, t} = gcd_ext(y, rem(x, y))
    {g, t, s - div(x, y) * t}
  end
end
