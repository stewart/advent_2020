defmodule Day16 do
  @moduledoc false

  import String, only: [to_integer: 1]

  # what is your ticket scanning error rate?
  # find values which are not valid for any rule, and sum
  def part1 do
    {rules, _yours, nearby} = data()

    nearby
    |> Enum.flat_map(& invalid_fields(&1, rules))
    |> Enum.sum()
  end

  defp invalid_fields(ticket, rules) do
    Enum.reject(ticket, & valid?(&1, rules))
  end

  defp valid?(value, rules) do
    Enum.any?(rules, fn {_name, range_a, range_b} -> 
      value in range_a or value in range_b
    end)
  end

  # reject the invalid tickets.
  # using the rest, find out which field is which using the nearby tickets.
  # with this knowledge, multiply the six 'departure'... values of your ticket.
  def part2 do
    {rules, yours, nearby} = data()

    valid_nearby_tickets =
      Enum.filter(nearby, & valid_ticket?(&1, rules))

    rule_mappings =
      determine_rule_mappings(rules, valid_nearby_tickets)

    departure_values =
      for {"departure" <> _, idx} <- rule_mappings, do: Enum.at(yours, idx)

    Enum.reduce(departure_values, &Kernel.*/2)
  end

  # using tickets and exclusions in rule overlaps,
  # solve for which rule corresponds to which field.
  defp determine_rule_mappings(rules, tickets) do
    cycle = Stream.cycle([true])
    mappings = Map.new(rules, fn {name, _, _} -> {name, nil} end)

    Enum.reduce_while(cycle, mappings, fn _, mappings ->
      solved? = Enum.all?(mappings, fn {_, idx} -> idx end)
      if solved? do
        {:halt, mappings}
      else
        {:cont, solve(mappings, tickets, rules)}
      end
    end)
  end

  defp valid_ticket?(ticket, rules) do
    Enum.all?(ticket, & valid?(&1, rules))
  end

  defp solve(mappings, tickets, rules) do
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

    split = & String.split(&1, "\n", trim: true)

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
