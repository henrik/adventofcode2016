defmodule Day5 do
  @input "reyedfim"
  @password_length 8
  @nth_char_of_hash 6

  # NOTE: Not optimised for speed (~38s on my MacBook Pro). Parallelise?
  def part1 do
    password =
      Stream.iterate(0, & &1 + 1)
      |> Stream.map(& md5_hash("#{@input}#{&1}"))
      |> Stream.filter(& String.starts_with?(&1, "00000"))
      |> Stream.map(& String.at(&1, @nth_char_of_hash - 1))
      |> Stream.take(@password_length)
      |> Enum.join

    IO.puts "Password: #{password}"
  end

  def md5_hash(input) do
    :crypto.hash(:md5, input) |> Base.encode16(case: :lower)
  end
end

Day5.part1
