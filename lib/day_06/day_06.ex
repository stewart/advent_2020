defmodule Day06 do
  @moduledoc false

  def run do
    part1()
    part2()
  end

  parse = fn input ->
    for answers <- String.split(input, "\n", trim: true) do
      answers |> String.graphemes() |> MapSet.new()
    end
  end

  @data [__DIR__, "DATA"]
        |> Path.join()
        |> File.read!()
        |> String.split("\n\n", trim: true)
        |> Enum.map(parse)

  def data do
    @data
  end

  # Count unique answers per group, count total.
  def part1 do
    data()
    |> Enum.map(fn answers -> Enum.reduce(answers, &MapSet.union/2) end)
    |> Enum.map(&MapSet.size/1)
    |> Enum.sum()
  end

  def part2 do
    data()
    |> Enum.map(fn answers -> Enum.reduce(answers, &MapSet.intersection/2) end)
    |> Enum.map(&MapSet.size/1)
    |> Enum.sum()
  end
end
