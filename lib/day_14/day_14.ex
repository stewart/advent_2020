defmodule Day14 do
  @moduledoc false

  use Bitwise

  ## Part 1

  def part1 do
    program = data()
    {mem, _mask} = execute_program(program, &execute_v1/2)
    mem |> Map.values() |> Enum.sum()
  end

  defp execute_v1({:mask, mask}, {mem, _}), do: {mem, mask}
  defp execute_v1({:mem, k, v}, {mem, mask}), do: {Map.put(mem, k, mask_val(v, mask)), mask}

  ## Part 2

  def part2 do
    program = data()
    {mem, _mask} = execute_program(program, &execute_v2/2)
    mem |> Map.values() |> Enum.sum()
  end

  defp execute_v2({:mask, mask}, {mem, _}), do: {mem, mask}

  defp execute_v2({:mem, k, v}, {mem, mask}) do
    mem = k |> mask_addr(mask) |> Enum.reduce(mem, &Map.put(&2, &1, v))
    {mem, mask}
  end

  defp mask_addr(addr, mask), do: addr |> mask(mask, &mask_addr/1) |> floating()

  defp mask_addr({_, 1}), do: 1
  defp mask_addr({v, 0}), do: v
  defp mask_addr({_, :x}), do: :x

  defp floating([]), do: [[]]
  defp floating([:x | tl]), do: tl |> floating() |> Enum.flat_map(&[[0 | &1], [1 | &1]])
  defp floating([hd | tl]), do: tl |> floating() |> Enum.map(&[hd | &1])

  ## Shared Code

  defp execute_program(instructions, method) do
    Enum.reduce(instructions, {%{}, nil}, method)
  end

  defp mask_val(val, mask), do: val |> mask(mask, &mask_val/1) |> binlist_to_int()

  defp mask_val({v, :x}), do: v
  defp mask_val({_, v}), do: v

  defp mask(val, mask, masker) do
    val |> int_to_binlist() |> pad() |> Enum.zip(mask) |> Enum.map(masker)
  end

  ## Data / Parsing

  @data [__DIR__, "DATA"]
        |> Path.join()
        |> File.stream!()
        |> Enum.map(&String.trim/1)

  @memory_regex ~r/mem\[(\d+)\] = (\d+)/

  def data do
    Enum.map(@data, fn
      <<"mask = ", mask::binary>> ->
        {:mask, parse_mask(mask)}

      input = <<"mem", _::binary>> ->
        [_, k, v] = Regex.run(@memory_regex, input)
        {:mem, String.to_integer(k), String.to_integer(v)}
    end)
  end

  defp parse_mask(""), do: []
  defp parse_mask(<<"0", rest::binary>>), do: [0 | parse_mask(rest)]
  defp parse_mask(<<"1", rest::binary>>), do: [1 | parse_mask(rest)]
  defp parse_mask(<<"X", rest::binary>>), do: [:x | parse_mask(rest)]

  @memsize 36
  def pad(list), do: pad(list, @memsize - length(list))
  def pad(list, 0), do: list
  def pad(list, n), do: [0 | pad(list, n - 1)]

  def int_to_binlist(n, res \\ [])
  def int_to_binlist(n, res) when n < 2, do: [n | res]
  def int_to_binlist(n, res), do: int_to_binlist(div(n, 2), [rem(n, 2) | res])

  def binlist_to_int(list), do: Enum.reduce(list, 0, &(&2 <<< 1 ||| &1))
end
