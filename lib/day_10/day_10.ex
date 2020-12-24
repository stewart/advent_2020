defmodule Day10 do
  @moduledoc false

  @data [__DIR__, "DATA"]
        |> Path.join()
        |> File.stream!()
        |> Stream.map(&String.trim/1)
        |> Stream.map(&String.to_integer/1)
        |> Enum.sort()

  def data do
    data = @data
    [0 | data] ++ [Enum.max(data) + 3]
  end

  def part1 do
    offsets = calculate_joltage_offsets(data())
    offsets[1] * offsets[3]
  end

  def part2 do
    valid_joltage_combinations(data())
  end

  defp calculate_joltage_offsets(joltages) do
    joltages
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.frequencies_by(fn [a, b] -> b - a end)
  end

  defp valid_joltage_combinations(joltages) do
    Map.fetch!(calculate_offset_combinations(joltages), Enum.max(joltages))
  end

  defp calculate_offset_combinations(joltages) do
    for joltage <- joltages, n <- 1..3, reduce: %{0 => 1} do
      acc ->
        acc
        |> Map.put_new(joltage, 0)
        |> Map.update!(joltage, &(&1 + (acc[joltage - n] || 0)))
    end
  end
end
