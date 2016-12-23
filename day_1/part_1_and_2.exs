defmodule Location do
  defstruct [ :x, :y ]

  def all_traversed(start_location, end_location) do
    for x <- start_location.x..end_location.x, y <- start_location.y..end_location.y do
      %Location{x: x, y: y}
    end -- [ end_location ]
  end
end

defmodule State do
  defstruct [ :facing, :location ]

  def update(old_state, turning, blocks) do
    direction = turn(turning, old_state.facing)

    %__MODULE__{
      facing: direction,
      location: %Location{
        x: move_x(old_state.location.x, direction, blocks),
        y: move_y(old_state.location.y, direction, blocks),
      },
    }
  end

  defp turn("L", :north), do: :west
  defp turn("L", :south), do: :east
  defp turn("L", :west), do: :south
  defp turn("L", :east), do: :north
  defp turn("R", :north), do: :east
  defp turn("R", :south), do: :west
  defp turn("R", :west), do: :north
  defp turn("R", :east), do: :south

  defp move_x(old_x, :east, blocks), do: old_x + blocks
  defp move_x(old_x, :west, blocks), do: old_x - blocks
  defp move_x(old_x, _, _), do: old_x

  defp move_y(old_y, :north, blocks), do: old_y + blocks
  defp move_y(old_y, :south, blocks), do: old_y - blocks
  defp move_y(old_y, _, _), do: old_y
end

defmodule Day1 do
  def part1 do
    %State{location: %Location{x: final_x, y: final_y}} = Enum.reduce instructions, initial_state, fn ({turning, blocks}, old_state) ->
      State.update(old_state, turning, blocks)
    end

    answer = abs(final_x) + abs(final_y)
    IO.puts "Answer to part 1: #{answer}"
  end

  def part2 do
    initial_visited_locations = []
    %Location{x: final_x, y: final_y} = Enum.reduce_while instructions, {initial_state, initial_visited_locations}, fn ({turning, blocks}, {old_state, old_visited_locations}) ->
      new_state = State.update(old_state, turning, blocks)

      traversed_locations = Location.all_traversed(old_state.location, new_state.location)

      previously_traversed_location = Enum.find traversed_locations, fn (loc) ->
        Enum.member?(old_visited_locations, loc)
      end

      if previously_traversed_location do
        {:halt, previously_traversed_location}
      else
        new_visited_locations = traversed_locations ++ old_visited_locations
        {:cont, {new_state, new_visited_locations}}
      end
    end

    answer = abs(final_x) + abs(final_y)
    IO.puts "Answer to part 2: #{answer}"
  end

  defp initial_state, do: %State{facing: :north, location: %Location{x: 0, y: 0}}

  defp instructions do
    raw_input = File.read!("input.txt")

    Regex.scan(~r/(L|R)(\d+)/, raw_input, capture: :all_but_first)
    |> Enum.map(fn ([turning, blocks]) -> {turning, String.to_integer(blocks)} end)
  end
end

Day1.part1
Day1.part2
