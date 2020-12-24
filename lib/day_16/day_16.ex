defmodule Day16 do
  @moduledoc false

  import String, only: [to_integer: 1]

  def part1 do
    {rules, _yours, nearby} = data()

    Enum.sum(
      for ticket <- nearby,
          field <- ticket,
          not valid?(field, rules),
          do: field
    )
  end

  # reject the invalid tickets.
  # using the rest, find out which field is which using the nearby tickets.
  # with this knowledge, multiply the six 'departure'... values of your ticket.
  def part2 do
    {rules, yours, nearby} = data()

    valid_nearby_tickets =
      for ticket <- nearby,
          valid_ticket?(ticket, rules),
          do: ticket

    mappings = solve_field_mapping(rules, valid_nearby_tickets)

    Enum.reduce(
      for({"departure" <> _, idx} <- mappings, do: Enum.at(yours, idx)),
      0,
      &Kernel.*/2
    )
  end

  defp solve_field_mapping(rules, tickets, known \\ %{}) do
    %{}
  end

  defp valid_ticket?(ticket, rules) do
    Enum.all?(ticket, &valid?(&1, rules))
  end

  defp valid?(field, rules) do
    Enum.any?(rules, fn {_, a, b} -> field in a or field in b end)
  end

  ## Gross data code below ---

  @data [__DIR__, "DATA"]
        |> Path.join()
        |> File.read!()
        |> String.split("\n\n", trim: true)

  def data do
    [
      field_rules,
      "your ticket:\n" <> yours,
      "nearby tickets:\n" <> nearby
    ] = @data

    split = &String.split(&1, "\n", trim: true)

    {
      field_rules |> split.() |> Enum.map(&parse_rule!/1),
      parse_ticket!(yours),
      nearby |> split.() |> Enum.map(&parse_ticket!/1)
    }
  end

  defp parse_rule!("" <> rules_str) do
    [_, name, mina, maxa, minb, maxb] =
      Regex.run(~r/^([\w\s]+): (\d+)-(\d+) or (\d+)-(\d+)$/, rules_str)

    {name, to_integer(mina)..to_integer(maxa), to_integer(minb)..to_integer(maxb)}
  end

  defp parse_ticket!("" <> ticket_str) do
    ticket_str |> String.split(",") |> Enum.map(&to_integer/1)
  end
end
