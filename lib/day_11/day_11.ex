defmodule Day11 do
  @moduledoc false

  compile_coords = fn {input_line, y}, acc ->
    chars = input_line |> String.split("", trim: true) |> Enum.with_index()

    Enum.reduce(chars, acc, fn
      {"#", x}, acc -> Map.put(acc, {x, y}, :taken)
      {"L", x}, acc -> Map.put(acc, {x, y}, :empty)
      {".", x}, acc -> Map.put(acc, {x, y}, :floor)
    end)
  end

  @data [__DIR__, "DATA"]
        |> Path.join()
        |> File.stream!()
        |> Stream.map(&String.trim/1)
        |> Enum.with_index()
        |> Enum.reduce(%{}, compile_coords)

  def data do
    @data
  end

  def part1 do
    solve(&adjacent_taken_seats/2, 4)
  end

  def part2 do
    solve(&visible_taken_seats/2, 5)
  end

  defp solve(visibility_fn, threshold) do
    data()
    |> simulate_until_settled(visibility_fn, threshold)
    |> taken_seat_count()
  end

  defp taken_seat_count(%{} = seat_map) do
    Enum.count(seat_map, fn {_, state} -> state == :taken end)
  end

  defp simulate_until_settled(%{} = seat_map, searcher, threshold) do
    cycle = Stream.cycle([true])

    Enum.reduce_while(cycle, {seat_map, _prev = %{}}, fn
      _, {seats, seats} -> {:halt, seats}
      _, {seats, _prev} -> {:cont, {simulate(seats, searcher, threshold), seats}}
    end)
  end

  def simulate(%{} = seat_map, searcher, threshold \\ 4) do
    Map.new(seat_map, fn {seat, state} ->
      case {state, searcher.(seat_map, seat)} do
        {:empty, 0} -> {seat, :taken}
        {:taken, n} when n >= threshold -> {seat, :empty}
        _ -> {seat, state}
      end
    end)
  end

  def adjacent_taken_seats(%{} = seat_map, seat) do
    Enum.count(neighbours(seat), &(seat_map[&1] == :taken))
  end

  defp neighbours({x, y} = _seat) do
    for dx <- -1..1, dy <- -1..1, {dx, dy} != {0, 0}, do: {x + dx, y + dy}
  end

  def visible_taken_seats(%{} = seat_map, seat) do
    Enum.count(visible(seat_map, seat), &(seat_map[&1] == :taken))
  end

  defp visible(%{} = seat_map, {x, y} = _seat) do
    cycle = Stream.cycle([true])
    directions = for dx <- -1..1, dy <- -1..1, {dx, dy} != {0, 0}, do: {dx, dy}

    Enum.reduce(directions, [], fn {dx, dy}, acc ->
      Enum.reduce_while(cycle, {acc, x + dx, y + dy}, fn _, {acc, ix, iy} ->
        case Map.get(seat_map, {ix, iy}) do
          :floor -> {:cont, {acc, ix + dx, iy + dy}}
          nil -> {:halt, acc}
          _ -> {:halt, [{ix, iy} | acc]}
        end
      end)
    end)
  end
end
