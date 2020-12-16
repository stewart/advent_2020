defmodule Day15 do
  @moduledoc false

  def data do
    [0, 13, 1, 16, 6, 17]
  end

  def part1 do
    {last, _} = play(data(), 2020)
    last
  end

  # this could probably be faster.
  def part2 do
    {last, _} = play(data(), 30_000_000)
    last
  end

  defp play(starting_numbers, turns) do
    Enum.reduce(1..turns, {nil, %{}}, fn
      n, {_, acc} when n <= length(starting_numbers) ->
        val = Enum.at(starting_numbers, n - 1)
        {val, Map.update(acc, val, [n], & [n, hd(&1)])}

      n, {prev, acc} ->
        val = case acc do
          %{^prev => [one, two | _]} -> one - two
          _ -> 0
        end

        {val, Map.update(acc, val, [n], & [n, hd(&1)])}
    end)
  end
end
