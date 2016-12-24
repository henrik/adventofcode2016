defmodule Room do
  @checksum_length 5

  defstruct [:encrypted_name, :sector_id, :checksum]

  def parse(as_string) do
    [_, encrypted_name, sector_id, checksum] = Regex.run(~r/([a-z-]+)-(\d+)\[([a-z]{5})\]/, as_string)

    %Room{
      encrypted_name: encrypted_name,
      sector_id: String.to_integer(sector_id),
      checksum: checksum,
    }
  end

  def real?(room) do
    room.checksum == expected_checksum(room)
  end

  def sector_id(%Room{sector_id: sid}), do: sid

  def decrypted_name(%Room{encrypted_name: encrypted_name, sector_id: sector_id}) do
    encrypted_name
    |> String.codepoints
    |> Enum.map(&decrypt_char(&1, sector_id))
    |> Enum.join
  end

  defp decrypt_char("-", _), do: " "
  defp decrypt_char(<<charcode>>, rotate_by) do
    char_index = charcode - ?a  # "a" is 0, "b" is 1, etc.

    alphabet_length = ?z - ?a + 1
    new_char_index = rem(char_index + rotate_by, alphabet_length)

    <<new_char_index + ?a>>  # Convert back from 0 to "a", 1 to "b", etc.
  end

  defp expected_checksum(%Room{encrypted_name: encrypted_name}) do
    letters =
      encrypted_name
      |> String.replace("-", "")
      |> String.codepoints

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
      rooms
      |> Enum.filter(&Room.real?/1)
      |> Enum.map(&Room.sector_id/1)
      |> Enum.sum

    IO.puts "Answer: #{answer}"
  end

  def part2 do
    rooms
    |> Enum.each(fn (room) ->
      IO.puts "#{Room.sector_id(room)}: #{Room.decrypted_name(room)}"
    end)
  end

  defp rooms do
    input
    |> Enum.map(&Room.parse/1)
  end

  defp input do
    File.read!("input/day_4.txt")
    |> String.split("\n", trim: true)
  end
end

Day4.part1
Day4.part2
