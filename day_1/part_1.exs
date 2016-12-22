defmodule State do
  defstruct [ :facing, :x, :y ]

  def update(old_state, turning, blocks) do
    direction = turn(turning, old_state.facing)

    %__MODULE__{
      facing: direction,
      x: move_x(old_state.x, direction, blocks),
      y: move_y(old_state.y, direction, blocks),
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

defmodule Runner do
  def run do
    raw_input = File.read!("input.txt")

    instructions =
      Regex.scan(~r/(L|R)(\d+)/, raw_input, capture: :all_but_first)
      |> Enum.map(fn ([turning, blocks]) -> {turning, String.to_integer(blocks)} end)

    initial_state = %State{facing: :north, x: 0, y: 0}

    %State{x: final_x, y: final_y} = Enum.reduce instructions, initial_state, fn ({turning, blocks}, old_state) ->
      State.update(old_state, turning, blocks)
    end

    answer = abs(final_x) + abs(final_y)
    IO.puts "Answer: #{answer}"
  end
end

Runner.run
