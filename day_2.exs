defmodule Keypad do
  @pad1 """
  123
  456
  789
  """

  @pad2 """
    1
   234
  56789
   ABC
    D
  """

  @blank " "

  def pad1, do: parse_pad(@pad1)
  def pad2, do: parse_pad(@pad2)

  def move(pad, from_digit, "U"), do: do_move(pad, from_digit, 0, -1)
  def move(pad, from_digit, "D"), do: do_move(pad, from_digit, 0, 1)
  def move(pad, from_digit, "L"), do: do_move(pad, from_digit, -1, 0)
  def move(pad, from_digit, "R"), do: do_move(pad, from_digit, 1, 0)

  defp do_move(pad, from_key, move_x, move_y) do
    current_y = pad |> Enum.find_index(fn (line) -> Enum.member?(line, from_key) end)
    current_x = pad |> Enum.at(current_y) |> Enum.find_index(fn(slot) -> slot == from_key end)

    # Avoid negative indices.
    target_y = max(current_y + move_y, 0)
    target_x = max(current_x + move_x, 0)

    res = pad |> Enum.at(target_y, []) |> Enum.at(target_x, @blank)

    case res do
      @blank -> from_key
      other  -> other
    end
  end

  defp parse_pad(raw_pad) do
    raw_pad
    |> String.trim_trailing
    |> String.split("\n")
    |> Enum.map(&String.codepoints/1)
  end
end

defmodule Day2 do
  def part1 do
    solve_for_keypad(Keypad.pad1)
  end

  def part2 do
    solve_for_keypad(Keypad.pad2)
  end

  defp solve_for_keypad(pad) do
    code =
      instruction_sets
      |> Enum.map(&digit_from_instruction_set(pad, &1))
      |> Enum.join

    IO.puts "Code: #{code}"
  end

  defp digit_from_instruction_set(pad, instructions) do
    initial_digit = "5"

    Enum.reduce instructions, initial_digit, fn (direction, current_digit) ->
      Keypad.move(pad, current_digit, direction)
    end
  end

  defp instruction_sets do
    File.read!("input/day_2.txt")
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.codepoints/1)
  end
end

Day2.part1
Day2.part2
