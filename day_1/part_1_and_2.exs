defmodule Location do
  defstruct [ :x, :y ]

  def all_traversed(start, ending) do
    for x <- start.x..ending.x, y <- start.y..ending.y do
      %Location{x: x, y: y}
    end
  end

  def move(%Location{x: x, y: y}, :east,  blocks), do: %Location{x: x + blocks, y: y}
  def move(%Location{x: x, y: y}, :west,  blocks), do: %Location{x: x - blocks, y: y}
  def move(%Location{x: x, y: y}, :north, blocks), do: %Location{x: x, y: y + blocks}
  def move(%Location{x: x, y: y}, :south, blocks), do: %Location{x: x, y: y - blocks}
end

defmodule State do
  defstruct [ :facing, :location ]

  def update(%State{facing: previously_facing, location: previous_location}, turn_to, blocks) do
    direction = turn(turn_to, previously_facing)
    location = Location.move(previous_location, direction, blocks)

    %State{facing: direction, location: location}
  end

  defp turn("L", :north), do: :west
  defp turn("L", :south), do: :east
  defp turn("L", :west), do: :south
  defp turn("L", :east), do: :north
  defp turn("R", :north), do: :east
  defp turn("R", :south), do: :west
  defp turn("R", :west), do: :north
  defp turn("R", :east), do: :south
end

defmodule Day1 do
  def part1 do
    final_state = Enum.reduce instructions, initial_state, fn ({turning, blocks}, old_state) ->
      State.update(old_state, turning, blocks)
    end

    IO.puts "Answer to part 1: #{answer_from_location final_state.location}"
  end

  def part2 do
    initial_visited_locations = []
    location = Enum.reduce_while instructions, {initial_state, initial_visited_locations}, fn ({turning, blocks}, {old_state, old_visited_locations}) ->
      new_state = State.update(old_state, turning, blocks)

      # Don't include the end location, or we'll always recognise it as previously traversed on the next go around.
      traversed_locations = Location.all_traversed(old_state.location, new_state.location) -- [new_state.location]

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

    IO.puts "Answer to part 2: #{answer_from_location location}"
  end

  defp initial_state, do: %State{facing: :north, location: %Location{x: 0, y: 0}}

  defp answer_from_location(%Location{x: x, y: y}), do: abs(x) + abs(y)

  defp instructions do
    raw_input = File.read!("input.txt")

    Regex.scan(~r/(L|R)(\d+)/, raw_input, capture: :all_but_first)
    |> Enum.map(fn ([turning, blocks]) -> {turning, String.to_integer(blocks)} end)
  end
end

Day1.part1
Day1.part2
