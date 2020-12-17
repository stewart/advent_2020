defmodule Day17 do
  @moduledoc false

  build_map = fn {line, y} ->
    line
    |> String.split("", trim: true)
    |> Stream.with_index()
    |> Enum.map(fn
      {"#", x} -> {{x, y}, :active}
      {".", x} -> {{x, y}, :inactive}
    end)
  end

  @data [__DIR__, "DATA"]
        |> Path.join()
        |> File.stream!()
        |> Stream.map(&String.trim/1)
        |> Stream.with_index()
        |> Stream.flat_map(build_map)
        |> Map.new()

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
