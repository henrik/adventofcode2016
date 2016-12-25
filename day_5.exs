defmodule Day5 do
  @input "reyedfim"
  @password_length 8

  # NOTE: Not optimised for speed (~38s on my MacBook Pro). Parallelise?
  def part1 do
    get_nth_char_of_hash = 6

    password =
      Stream.iterate(0, & &1 + 1)
      |> Stream.map(& md5_hash("#{@input}#{&1}"))
      |> Stream.filter(& String.starts_with?(&1, "00000"))
      |> Stream.map(& String.at(&1, get_nth_char_of_hash - 1))
      |> Stream.take(@password_length)
      |> Enum.join

    IO.puts "Password: #{password}"
  end

  # NOTE: Even slower than part 1 but has fancy output…
  # TODO: Not cleaned up!
  # TODO: Parallelise!
  def part2 do
    IO.puts ""
    IO.puts "Password:"

    blank_password = List.duplicate("_", @password_length)

    hex_chars = ~w[0 1 2 3 4 5 6 7 8 9 a b c d e f]
    hex_chars_length = length(hex_chars)

    # This slows down the animated output so it looks good.
    update_placeholder_every_n_iterations = 500

    Stream.iterate(0, & &1 + 1) |> Enum.reduce_while(blank_password, fn (i, password_so_far) ->

      hash = md5_hash("#{@input}#{i}")

      new_password =
        if String.starts_with?(hash, "00000") do
          position = String.at(hash, 5)

          # "ignore invalid positions"
          if Enum.member?(~w[0 1 2 3 4 5 6 7], position) do
            position = String.to_integer(position)

            # "Use only the first result for each position"
            if Enum.at(password_so_far, position) == "_" do
              char = String.at(hash, 6)
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

      shown_password = new_password |> Enum.with_index |> Enum.map(fn
        {"_", j} ->
          index = rem(div(i, update_placeholder_every_n_iterations) + j, hex_chars_length)
          char = Enum.at(hex_chars, index)
          [IO.ANSI.yellow, char, IO.ANSI.reset]
        {real_char, _i} ->
          [IO.ANSI.green, real_char, IO.ANSI.reset]
      end)

      IO.write "\r#{shown_password |> Enum.join} [##{i}]"

      if Enum.member?(new_password, "_") do
        {:cont, new_password}
      else
        IO.puts ""
        {:halt, new_password}
      end
    end)
  end

  def md5_hash(input) do
    :crypto.hash(:md5, input) |> Base.encode16(case: :lower)
  end
end

Day5.part1
Day5.part2
