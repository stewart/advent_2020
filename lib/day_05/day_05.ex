defmodule Day05 do
  @moduledoc false

  @rows 0..127
  @seats 0..7

  def run do
    part1()
    part2()
  end

  @data [__DIR__, "DATA"]
        |> Path.join()
        |> File.stream!()
        |> Stream.map(&String.trim/1)
        |> Enum.map(fn <<row::binary-size(7), seat::binary>> -> {row, seat} end)

  def data do
    for {row, seat} <- @data,
      into: MapSet.new(),
      do: row_number(row) * 8 + seat_number(seat)
  end

  # multiply row number by 8 and add column to get seat ID, find highest id.
  def part1 do
    Enum.max(data())
  end

  # find your seat id -- it is _not_ present in the list but has immediate neighbours (ID +1, ID -1)
  def part2 do
    seats = data()

    Enum.find_value(seats, fn id ->
      if (id + 2 in seats) and not (id + 1 in seats) do
        id + 1
      end
    end)
  end

  defp split(range) do
    Enum.split(range, div(Enum.count(range), 2))
  end

  defp front(path, range, continuation) do
    case split(range) do
      {[result], _} -> result
      {front, _} -> continuation.(path, front)
    end
  end

  defp back(path, range, continuation) do
    case split(range) do
      {_, [result]} -> result
      {_, back} -> continuation.(path, back)
    end
  end

  defp row_number(path, range \\ @rows)
  defp row_number(<<"F", rest::binary>>, range), do: front(rest, range, &row_number/2)
  defp row_number(<<"B", rest::binary>>, range), do: back(rest, range, &row_number/2)

  defp seat_number(path, range \\ @seats)
  defp seat_number(<<"L", rest::binary>>, range), do: front(rest, range, &seat_number/2)
  defp seat_number(<<"R", rest::binary>>, range), do: back(rest, range, &seat_number/2)
end
