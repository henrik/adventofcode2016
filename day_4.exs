defmodule Room do
  @checksum_length 5

  defstruct [:name, :sector_id, :checksum]

  def parse(as_string) do
    [_, name, sector_id, checksum] = Regex.run(~r/([a-z-]+)-(\d+)\[([a-z]{5})\]/, as_string)

    %Room{
      name: name,
      sector_id: String.to_integer(sector_id),
      checksum: checksum,
    }
  end

  def real?(room) do
    room.checksum == expected_checksum(room)
  end

  def sector_id(%Room{sector_id: sid}), do: sid

  defp expected_checksum(%Room{name: name}) do
    letters =
      name
      |> String.codepoints
      |> Enum.reject(& &1 == "-")

    letters
    |> Enum.sort
    |> Enum.chunk_by(& &1)
    |> Enum.sort_by(fn (chunk) -> {-length(chunk), hd(chunk)} end)
    |> Enum.take(@checksum_length)
    |> Enum.map(&Kernel.hd/1)
    |> Enum.join
  end
end

defmodule Day4 do
  def part1 do
    answer =
      input
      |> Enum.map(&Room.parse/1)
      |> Enum.filter(&Room.real?/1)
      |> Enum.map(&Room.sector_id/1)
      |> Enum.sum

    IO.puts "Answer: #{answer}"
  end

  defp input do
    File.read!("input/day_4.txt")
    |> String.split("\n", trim: true)
  end
end

Day4.part1
