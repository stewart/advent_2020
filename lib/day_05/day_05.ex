defmodule Day05 do
  @moduledoc false

  def run do
    part1()
    part2()
  end

  one_pattern = :binary.compile_pattern(~w[F L])
  nil_pattern = :binary.compile_pattern(~w[B R])

  convert_to_seat_id = fn line ->
    line
    |> String.replace(one_pattern, "0")
    |> String.replace(nil_pattern, "1")
    |> String.to_integer(2)
  end

  @data [__DIR__, "DATA"]
        |> Path.join()
        |> File.stream!()
        |> Stream.map(&String.trim/1)
        |> Stream.map(convert_to_seat_id)
        |> MapSet.new()

  def data do
    @data
  end

  # Highest seat ID.
  def part1 do
    Enum.max(data())
  end

  # Seat ID which is _not_ present in the list, but has immediate neighbours.
  def part2 do
    seats = data()

    Enum.find_value(seats, fn id ->
      if (id + 2) in seats and not ((id + 1) in seats) do
        id + 1
      end
    end)
  end
end
