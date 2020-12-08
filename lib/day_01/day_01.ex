defmodule Day01 do
  @moduledoc false

  def run do
    part1()
    part2()
  end

  @data [__DIR__, "DATA"]
        |> Path.join()
        |> File.stream!()
        |> Stream.map(&String.trim/1)
        |> Enum.map(&String.to_integer/1)

  def data do
    @data
  end

  # find permutation of two inputs which sums to 2020, multiply for answer
  def part1 do
    all_nums = data()

    Enum.reduce_while(all_nums, :ok, fn current, _ ->
      case Enum.find(all_nums -- [current], &(&1 + current == 2020)) do
        nil -> {:cont, :ok}
        counterpart -> {:halt, current * counterpart}
      end
    end)
  end

  # find permutation of three inputs which sums to 2020, multiply for answer
  def part2 do
    all_nums = data()

    Enum.reduce_while(all_nums, :ok, fn alpha, _ ->
      Enum.reduce_while(all_nums -- [alpha], :ok, fn bravo, _ ->
        case Enum.find(all_nums -- [alpha, bravo], &(&1 + alpha + bravo == 2020)) do
          nil -> {:cont, {:cont, :ok}}
          charlie -> {:halt, {:halt, alpha * bravo * charlie}}
        end
      end)
    end)
  end
end
