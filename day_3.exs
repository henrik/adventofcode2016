defmodule Triangle do
  def possible?({a, b, c}) when a + b > c and a + c > b and b + c > a, do: true
  def possible?(_), do: false
end

defmodule Day3 do
  def part1 do
    answer =
      input
      |> Enum.map(&List.to_tuple/1)
      |> Enum.count(&Triangle.possible?/1)

    IO.puts "Number of possible triangles: #{answer}"
  end

  def part2 do
    answer =
      input
      |> Enum.chunk(3)
      |> Enum.flat_map(&List.zip/1)
      |> Enum.count(&Triangle.possible?/1)

      IO.puts "Number of possible triangles: #{answer}"
  end

  defp input do
    File.read!("input/day_3.txt")
    |> String.trim
    |> String.split("\n")
    |> Enum.map(fn (line) ->
      line |> String.split |> Enum.map(&String.to_integer/1)
    end)
  end
end

Day3.part1
Day3.part2
