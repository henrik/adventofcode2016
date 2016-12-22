defmodule State do
  defstruct [ :facing, :x, :y ]

  def update(old_state, turning, blocks) do
    new_direction = Direction.turn(turning, old_state.facing)

    %__MODULE__{
      facing: new_direction,
      x: update_x(old_state.x, new_direction, blocks),
      y: update_y(old_state.y, new_direction, blocks),
    }
  end

  defp update_x(old_x, :east, blocks), do: old_x + blocks
  defp update_x(old_x, :west, blocks), do: old_x - blocks
  defp update_x(old_x, _, _), do: old_x

  defp update_y(old_y, :north, blocks), do: old_y + blocks
  defp update_y(old_y, :south, blocks), do: old_y - blocks
  defp update_y(old_y, _, _), do: old_y
end

defmodule Direction do
  def turn("L", :north), do: :west
  def turn("L", :south), do: :east
  def turn("L", :west), do: :south
  def turn("L", :east), do: :north
  def turn("R", :north), do: :east
  def turn("R", :south), do: :west
  def turn("R", :west), do: :north
  def turn("R", :east), do: :south
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
