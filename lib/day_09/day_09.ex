defmodule Day09 do
  @moduledoc false

  @data [__DIR__, "DATA"]
        |> Path.join()
        |> File.stream!()
        |> Stream.map(&String.trim/1)
        |> Enum.map(&String.to_integer/1)

  # encrypted with the eXchange-Masking Addition System [XMAS]
  # - preamble of 25 numbers
  # - after that, each number in the sequence should be the sum of any
  #   two immediately preceding numbers
  def data do
    @data
  end

  # find a number in the list which is _not_ valid
  # this means it is not the sum of two of the preceding 25 numbers
  def part1 do
    {preamble, data} = Enum.split(data(), 25)

    Enum.reduce_while(data, preamble, fn next, previous ->
      if valid_in_sequence?(next, previous) do
        {:cont, continue(previous, next)}
      else
        {:halt, next}
      end
    end)
  end

  # find a contiguous segment of numbers in the overall set which sum to part1's result.
  # then sum the largest and smallest of those numbers for the answer
  def part2 do
    target_value = 258_585_477
    data() |> find_weakness(target_value) |> exploit_weakness()
  end

  defp find_weakness([_ | tail] = numbers, target_value) do
    case detect_weakness(numbers, target_value) do
      {:ok, weak_numbers} -> weak_numbers
      :error -> find_weakness(tail, target_value)
    end
  end

  defp detect_weakness([head | rest], target_value) do
    Enum.reduce_while(rest, {[head], head}, fn num, {acc, total} ->
      case total + num do
        ^target_value -> {:halt, {:ok, [num | acc]}}
        n when n > target_value -> {:halt, :error}
        n -> {:cont, {[num | acc], n}}
      end
    end)
  end

  defp exploit_weakness(weak_numbers) do
    {min, max} = Enum.min_max(weak_numbers)
    min + max
  end

  defp valid_in_sequence?(next, previous) when is_integer(next) and is_list(previous) do
    Enum.any?(permutations(previous), &(Enum.sum(&1) == next))
  end

  def permutations(list) do
    for elem <- list, other <- list -- [elem], do: [elem, other]
  end

  defp continue([_ | preamble], next), do: preamble ++ [next]
end
