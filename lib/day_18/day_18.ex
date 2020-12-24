defmodule Day18 do
  @moduledoc false

  def part1 do
    data()
    |> Enum.map(&parse_p1/1)
    |> Enum.map(&eval/1)
    |> Enum.sum()
  end

  def part2 do
    # data()
  end

  ## Data

  @data [__DIR__, "DATA"]
        |> Path.join()
        |> File.stream!()
        |> Enum.map(&String.trim/1)

  def data do
    Enum.map(@data, &tokenize/1)
  end

  defp tokenize(""), do: []
  defp tokenize(<<" ", tail::binary>>), do: tokenize(tail)
  defp tokenize(<<"+", tail::binary>>), do: [:+ | tokenize(tail)]
  defp tokenize(<<"*", tail::binary>>), do: [:* | tokenize(tail)]
  defp tokenize(<<"(", tail::binary>>), do: [:l | tokenize(tail)]
  defp tokenize(<<")", tail::binary>>), do: [:r | tokenize(tail)]
  defp tokenize(<<num, tail::binary>>), do: [String.to_integer(<<num>>) | tokenize(tail)]

  # parse tokens into nested three-item lists
  defp parse_p1(tokens, acc \\ [nil])
  defp parse_p1([], [acc]), do: acc
  defp parse_p1([:l | tail], acc), do: parse_p1(tail, [nil | acc])
  defp parse_p1([:r | tail], [e | acc]), do: parse_p1([e | tail], acc)
  defp parse_p1([op | tail], [e | acc]) when op in [:+, :*], do: parse_p1(tail, [[op, e] | acc])
  defp parse_p1([ls | tail], [nil | acc]), do: parse_p1(tail, [ls | acc])
  defp parse_p1([rs | tail], [[op, ls] | acc]), do: parse_p1(tail, [[op, ls, rs] | acc])

  # evaluates a nested list of three-item math instructions
  def eval(n) when is_integer(n), do: n
  def eval([:+, l, r]), do: eval(l) + eval(r)
  def eval([:*, l, r]), do: eval(l) * eval(r)
end
