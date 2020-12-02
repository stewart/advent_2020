defmodule Day15 do
  @moduledoc false

  def run do
    part1()
    part2()
  end

  @data [__DIR__, "DATA"]
        |> Path.join()
        |> File.stream!()
        |> Enum.to_list()

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
