defmodule Day07 do
  @moduledoc false

  def run do
    part1()
    part2()
  end

  parse_bags = fn
    ["no other bags"] ->
      %{}

    bags ->
      Map.new(bags, fn bag ->
        [_, count, color] = Regex.run(~r/^(\d+)\s+(.+)\s+bags?$/, bag)
        {color, String.to_integer(count)}
      end)
  end

  parse = fn input ->
    [outer, inner] = String.split(input, " contain ", parts: 2, trim: true)
    [_, outer] = Regex.run(~r/^(.+) bags$/, outer)
    inner = inner |> String.replace(".", "") |> String.split(", ", trim: true)
    {outer, parse_bags.(inner)}
  end

  @data [__DIR__, "DATA"]
        |> Path.join()
        |> File.read!()
        |> String.split("\n", trim: true)
        |> Enum.map(&String.trim/1)
        |> Map.new(parse)

  def data do
    @data
  end

  # how many bag colors can eventually contain at least one 'shiny gold' bag?
  def part1 do
    rules = data()
    Enum.count(rules, fn {bag, _} -> allowed?(rules, bag, "shiny gold") end)
  end

  # how many bags are specified in total by your single 'shiny gold' bag?
  def part2 do
    rules = data()
    total_baggage(rules, "shiny gold") - 1
  end

  defp allowed?(rules, outer, inner) do
    Enum.any?(rules[outer], fn
      {^inner, _} -> true
      {bag, _} -> allowed?(rules, bag, inner)
    end)
  end

  def total_baggage(rules, color) do
    Enum.reduce(rules[color], 1, fn {bag, count}, acc ->
      count * total_baggage(rules, bag) + acc
    end)
  end
end
