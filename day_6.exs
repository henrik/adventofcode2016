defmodule Day6 do
  def part1 do
    answer =
      inverted_input
      |> Enum.map(&most_frequent_character/1)

    IO.puts "Answer: #{answer}"
  end

  def part2 do
    answer =
      inverted_input
      |> Enum.map(&least_frequent_character/1)

    IO.puts "Answer: #{answer}"
  end

  defp most_frequent_character(charlist) do
    charcode =
      charlist
      |> Enum.sort
      |> Enum.chunk_by(& &1)
      |> Enum.sort_by(& -length(&1))
      |> hd
      |> hd

    <<charcode>>
  end

  defp least_frequent_character(charlist) do
    charcode =
      charlist
      |> Enum.sort
      |> Enum.chunk_by(& &1)
      |> Enum.sort_by(& length(&1))
      |> hd
      |> hd

    <<charcode>>
  end

  defp inverted_input do
    input
    |> Enum.map(&Kernel.to_charlist/1)
    |> List.zip
    |> Enum.map(&Tuple.to_list/1)
    |> IO.inspect
  end

  defp input do
    File.read!("input/day_6.txt")
    |> String.split("\n", trim: true)
  end
end

Day6.part1
Day6.part2
