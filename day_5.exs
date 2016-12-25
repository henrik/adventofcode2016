defmodule Day5 do
  @input "reyedfim"
  @password_length 8
  @prefix "00000"

  @blank_slot "_"
  @hex_chars ~w[0 1 2 3 4 5 6 7 8 9 a b c d e f]
  @hex_chars_length length(@hex_chars)

  # This slows down the animated output so it looks good.
  @update_placeholder_every_n_iterations 500

  # NOTE: Not optimised for speed (~38s on my MacBook Pro). Parallelise?
  def part1 do
    get_nth_char_of_hash = 6

    password =
      stream_of_numbers
      |> Stream.map(& md5_hash("#{@input}#{&1}"))
      |> Stream.filter(& String.starts_with?(&1, @prefix))
      |> Stream.map(& String.at(&1, get_nth_char_of_hash - 1))
      |> Stream.take(@password_length)
      |> Enum.join

    IO.puts "Password: #{password}"
  end

  # NOTE: Even slower than part 1 but has fancy output…
  # TODO: Not cleaned up!
  # TODO: Parallelise!
  def part2 do
    position_at_position = 6
    pw_char_at_position = 7

    blank_password = List.duplicate(@blank_slot, @password_length)

    IO.puts ""
    IO.puts "Password:"

    stream_of_numbers |> Enum.reduce_while(blank_password, fn (i, password_so_far) ->
      hash = md5_hash("#{@input}#{i}")

      new_password =
        if String.starts_with?(hash, @prefix) do
          position = String.at(hash, position_at_position - 1)

          # "ignore invalid positions"
          if Enum.member?(~w[0 1 2 3 4 5 6 7], position) do
            position = String.to_integer(position)

            # "Use only the first result for each position"
            if Enum.at(password_so_far, position) == @blank_slot do
              char = String.at(hash, pw_char_at_position - 1)
              List.replace_at(password_so_far, position, char)
            else
              password_so_far
            end
          else
            password_so_far
          end
        else
          password_so_far
        end

      IO.write ["\r", password_to_show(new_password, i), " [##{i}]"]

      if Enum.member?(new_password, @blank_slot) do
        {:cont, new_password}
      else
        IO.puts ""
        {:halt, new_password}
      end
    end)
  end

  defp password_to_show(password, i) do
    password |> Enum.with_index |> Enum.map(fn
      {@blank_slot, j} ->
        index = rem(div(i, @update_placeholder_every_n_iterations) + j, @hex_chars_length)
        char = Enum.at(@hex_chars, index)
        [IO.ANSI.yellow, char, IO.ANSI.reset]
      {real_char, _i} ->
        [IO.ANSI.green, real_char, IO.ANSI.reset]
    end)
  end

  defp stream_of_numbers, do: Stream.iterate(0, & &1 + 1)

  defp md5_hash(input) do
    :crypto.hash(:md5, input) |> Base.encode16(case: :lower)
  end
end

Day5.part1
Day5.part2
