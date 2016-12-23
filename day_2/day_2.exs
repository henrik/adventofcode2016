defmodule Keypad do
  def move(n, "U") when n in 1..3, do: n
  def move(n, "U"), do: n - 3

  def move(n, "D") when n in 7..9, do: n
  def move(n, "D"), do: n + 3

  def move(n, "L") when n in [1, 4, 7], do: n
  def move(n, "L"), do: n - 1

  def move(n, "R") when n in [3, 6, 9], do: n
  def move(n, "R"), do: n + 1
end

defmodule Day2 do
  def part1 do
    code =
      instruction_sets
      |> Enum.map(&digit_from_instruction_set/1)
      |> Enum.join

    IO.puts "Code: #{code}"
  end

  defp digit_from_instruction_set(instructions) do
    initial_digit = 5

    Enum.reduce instructions, initial_digit, fn (direction, current_digit) ->
      Keypad.move(current_digit, direction)
    end
  end

  defp instruction_sets do
    File.read!("input.txt")
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.codepoints/1)
  end
end

Day2.part1
