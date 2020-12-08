defmodule Day03 do
  @moduledoc false

  def run do
    part1()
    part2()
  end

  compile_coords = fn {input_line, y}, acc ->
    chars = input_line |> String.split("", trim: true) |> Enum.with_index()

    Enum.reduce(chars, acc, fn
      {".", _}, acc -> acc
      {"#", x}, acc -> MapSet.put(acc, {x, y})
    end)
  end

  @data [__DIR__, "DATA"]
        |> Path.join()
        |> File.stream!()
        |> Stream.map(&String.trim/1)
        |> Enum.with_index()
        |> Enum.reduce(MapSet.new(), compile_coords)

  def data do
    @data
  end

  # move right 3, down 1. check if there's a tree there. repeat until you reach the bottom.
  def part1 do
    count_trees_hit(data(), {3, 1})
  end

  # the same but with a bunch of different slopes.
  def part2 do
    coords = data()

    [{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}]
    |> Task.async_stream(&count_trees_hit(coords, &1), limit: :infinity)
    |> Stream.map(fn {:ok, result} -> result end)
    |> Enum.reduce(&Kernel.*/2)
  end

  def count_trees_hit(coords, {x_step, y_step} = _slope) do
    max_y = coords |> Enum.max_by(&elem(&1, 1)) |> elem(1)
    width = coords |> Enum.max_by(&elem(&1, 0)) |> elem(0) |> Kernel.+(1)

    Enum.reduce(0..max_y, {0, 0, 0}, fn _, {x, y, trees} ->
      {x, y} = {rem(x + x_step, width), y + y_step}
      {x, y, if({x, y} in coords, do: trees + 1, else: trees)}
    end)
    |> elem(2)
  end
end
