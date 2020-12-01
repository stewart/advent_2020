defmodule Day12 do
  @moduledoc false

  def run do
    part1()
    part2()
  end

  @data [__DIR__, "DATA"]
        |> Path.join()
        |> File.read!()

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
