defmodule Day04 do
  @moduledoc false

  def run do
    part1()
    part2()
  end

  parse = fn attr_list ->
    for <<key::binary-size(3), ":", value::binary>> <- attr_list,
      into: %{},
      do: {key, value}
  end

  @data [__DIR__, "DATA"]
        |> Path.join()
        |> File.read!()
        |> String.split("\n\n")
        |> Stream.map(& &1 |> String.replace("\n", " ") |> String.split(" ", trim: true))
        |> Enum.map(parse)

  def data do
    @data
  end

  # How many passports have all required fields?
  def part1 do
    Enum.count(data(), &has_required_fields?/1)
  end

  # How many passports have all required fields and are also valid?
  def part2 do
    Enum.count(data(), fn passport ->
      has_required_fields?(passport) and all_fields_valid?(passport)
    end)
  end

  @required ~w[byr iyr eyr hgt hcl ecl pid]

  defp has_required_fields?(passport) do
    Enum.all?(@required, & Map.has_key?(passport, &1))
  end

  defp all_fields_valid?(passport) do
    Enum.all?(passport, fn {key, value} -> valid?(key, value) end)
  end

  # Stricter validations per field
  defp valid?(field, value)
  defp valid?("byr", value), do: in_range?(value, 1920..2002)
  defp valid?("iyr", value), do: in_range?(value, 2010..2020)
  defp valid?("eyr", value), do: in_range?(value, 2020..2030)
  defp valid?("hgt", value), do: valid_height?(value)
  defp valid?("hcl", value), do: Regex.match?(~r/^\#[0-9,a-f]{6}$/, value)
  defp valid?("ecl", value), do: value in ~w[amb blu brn gry grn hzl oth]
  defp valid?("pid", value), do: Regex.match?(~r/^\d{9}$/, value)
  defp valid?("cid", _valu), do: true
  defp valid?(_unkn, _valu), do: false

  defp in_range?(value, range) when is_binary(value) do
    value = if is_binary(value), do: String.to_integer(value)
    value in range
  rescue
    ArgumentError -> false
  end

  defp valid_height?(value) do
    case Regex.run(~r/(\d+)(cm|in)/, value) do
      [_, height, "cm"] -> in_range?(height, 150..193)
      [_, height, "in"] -> in_range?(height, 59..76)
      _ -> false
    end
  end
end
