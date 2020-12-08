defmodule Day02 do
  @moduledoc false

  import String, only: [to_integer: 1]

  def run do
    part1()
    part2()
  end

  parse_policy_str = fn policy_str ->
    [policy, password] = String.split(policy_str, ": ", parts: 2)
    [count_range, character] = String.split(policy, " ", parts: 2)
    [count_min, count_max] = String.split(count_range, "-", parts: 2)

    {{character, to_integer(count_min), to_integer(count_max)},
     String.split(password, "", trim: true)}
  end

  @data [__DIR__, "DATA"]
        |> Path.join()
        |> File.stream!()
        |> Stream.map(&String.trim/1)
        |> Stream.map(parse_policy_str)
        |> Enum.to_list()

  def data do
    @data
  end

  def part1 do
    Enum.count(data(), fn {{expected, min, max}, password} ->
      Enum.count(password, fn
        ^expected -> true
        _ -> false
      end) in min..max
    end)
  end

  def part2 do
    Enum.count(data(), fn {{expected, one, two}, password} ->
      case {Enum.at(password, one - 1), Enum.at(password, two - 1)} do
        {^expected, ^expected} -> false
        {_, ^expected} -> true
        {^expected, _} -> true
        {_, _} -> false
      end
    end)
  end
end
