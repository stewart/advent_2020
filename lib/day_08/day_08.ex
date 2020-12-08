defmodule Day08 do
  @moduledoc false

  defmodule Program do
    defstruct instruction: 0, accumulator: 0, memory: %{}

    alias __MODULE__

    def new(instructions) when is_list(instructions) do
      memory =
        instructions
        |> Stream.with_index()
        |> Map.new(fn {instruction, index} -> {index, instruction} end)

      %Program{memory: memory}
    end

    def modify_instruction(%Program{memory: memory} = program, instr_id) do
      modified =
        case memory[instr_id] do
          {:nop, arg} -> Map.put(memory, instr_id, {:jmp, arg})
          {:jmp, arg} -> Map.put(memory, instr_id, {:nop, arg})
          _ -> memory
        end

      %Program{program | memory: modified}
    end

    def run(%Program{instruction: instr, memory: memory} = program) do
      case memory[instr] do
        {:nop, _} -> advance(program)
        {:acc, arg} -> program |> update_accumulator(arg) |> advance()
        {:jmp, offset} -> jump(program, offset)
      end
    end

    # Program is done if instruction pointer is to an OOM location.
    def done?(%Program{memory: memory, instruction: instruction}) do
      is_nil(memory[instruction])
    end

    defp jump(%Program{instruction: instr} = program, offset) when is_integer(offset) do
      %Program{program | instruction: instr + offset}
    end

    defp advance(program) do
      jump(program, 1)
    end

    defp update_accumulator(%Program{accumulator: acc} = program, value) when is_integer(value) do
      %Program{program | accumulator: acc + value}
    end
  end

  # single-word operation followed by signed number arguments
  parse = fn <<op::binary-size(3), " ", arg::binary>> ->
    {String.to_atom(op), String.to_integer(arg)}
  end

  @data [__DIR__, "DATA"]
        |> Path.join()
        |> File.read!()
        |> String.split("\n", trim: true)
        |> Enum.map(&String.trim/1)
        |> Enum.map(parse)

  def data do
    @data
  end

  # immediately before the program starts a loop (runs an instruction for the second time)
  # identify the value in the program's accumulator
  def part1 do
    program = Program.new(data())
    {:ok, program} = run_until_loop(program)
    program.accumulator
  end

  # identify a permutation of the program which terminates rather than looping.
  # a single `jmp` should be a `nop`, or a `nop` should be a `jmp`.
  # the program will terminate by attempting to access an OOM instruction.
  def part2 do
    program = Program.new(data())
    program = fix_corruption(program)
    program = run_until_done(program)
    program.accumulator
  end

  # a single instruction in the program is corrupted.
  # a non-corrupted program runs until the instruction pointer is outside of memory.
  defp fix_corruption(program) do
    suspect_instructions = for {id, {op, _}} when op in [:jmp, :nop] <- program.memory, do: id

    Enum.find_value(suspect_instructions, fn instr_id ->
      modified_program = Program.modify_instruction(program, instr_id)

      case run_until_loop(modified_program) do
        {:ok, _} -> false
        :error -> modified_program
      end
    end)
  end

  # runs the program until it loops
  # returns {:ok, final_state} if the program loops, :error otherwise
  defp run_until_loop(program) do
    cycle = Stream.cycle([nil])
    initial = {program, MapSet.new()}

    Enum.reduce_while(cycle, initial, fn _, {program, seen} ->
      if program.instruction in seen do
        {:halt, {:ok, program}}
      else
        updated = Program.run(program)

        if Program.done?(updated) do
          {:halt, :error}
        else
          {:cont, {updated, MapSet.put(seen, program.instruction)}}
        end
      end
    end)
  end

  defp run_until_done(program) do
    cycle = Stream.cycle([nil])

    Enum.reduce_while(cycle, program, fn _, program ->
      updated = Program.run(program)

      if Program.done?(updated) do
        {:halt, updated}
      else
        {:cont, updated}
      end
    end)
  end
end
