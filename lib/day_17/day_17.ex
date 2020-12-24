defmodule Day17 do
  @moduledoc false

  defmodule Cube do
    def new(seed) do
      Map.new(seed)
    end

    def cycle(%{} = cube) do
      Map.new(coords(cube), &update(&1, cube))
    end

    def update(coords, cube) do
      case {cube[coords], active_neighbours(coords, cube)} do
        {:active, n} when n in [2, 3] -> {coords, :active}
        {:inactive, 3} -> {coords, :active}
        _ -> {coords, :inactive}
      end
    end

    def total_active(%{} = cube) do
      Enum.count(for {_, :active} <- cube, do: true)
    end

    def active_neighbours(coords, %{} = cube) do
      Enum.count(neighbours(coords), &active?(cube, &1))
    end

    def active?(%{} = cube, coords), do: cube[coords] == :active

    def coords(%{} = cube) do
      for {xyz, _} <- cube,
          coords <- [xyz | neighbours(xyz)],
          into: MapSet.new(),
          do: coords
    end

    def neighbours({x, y, z}) do
      for dx <- -1..1,
          dy <- -1..1,
          dz <- -1..1,
          {dx, dy, dz} != {0, 0, 0},
          do: {x + dx, y + dy, z + dz}
    end
  end

  build_map = fn {line, y} ->
    line
    |> String.split("", trim: true)
    |> Stream.with_index()
    |> Enum.map(fn
      {"#", x} -> {{x, y, 0}, :active}
      {".", x} -> {{x, y, 0}, :inactive}
    end)
  end

  @data [__DIR__, "DATA"]
        |> Path.join()
        |> File.stream!()
        |> Stream.map(&String.trim/1)
        |> Stream.with_index()
        |> Stream.flat_map(build_map)
        |> Cube.new()

  def data do
    @data
  end

  def part1 do
    data()
  end

  def part2 do
    data()
  end
end
