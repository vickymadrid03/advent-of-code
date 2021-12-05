defmodule Aoc.Day02 do
  @positions %{
    horizontal: 0,
    depth: 0,
    aim: 0
  }

  def puzzle1(input) do
    solve_puzzle(input, &update_position/3)
  end

  def puzzle2(input) do
    solve_puzzle(input, &update_position_with_aim/3)
  end

  defp solve_puzzle(input, position_function) do
    positions =
      String.split(input, "\n")
      |> Enum.reduce(@positions, fn instruction, positions ->
        [direction, units] = String.split(instruction)

        position_function.(positions, direction, String.to_integer(units))
      end)

    positions[:depth] * positions[:horizontal]
  end

  defp update_position(positions, "up", units),
    do: Map.update(positions, :depth, 0, &(&1 - units))

  defp update_position(positions, "down", units),
    do: Map.update(positions, :depth, 0, &(&1 + units))

  defp update_position(positions, "forward", units),
    do: Map.update(positions, :horizontal, 0, &(&1 + units))

  defp update_position(positions, _, _), do: positions

  defp update_position_with_aim(positions, "up", units),
    do: Map.update(positions, :aim, 0, &(&1 - units))

  defp update_position_with_aim(positions, "down", units),
    do: Map.update(positions, :aim, 0, &(&1 + units))

  defp update_position_with_aim(positions, "forward", units) do
    Map.update(positions, :horizontal, 0, &(&1 + units))
    |> Map.update(:depth, 0, &(&1 + positions[:aim] * units))
  end

  defp update_position_with_aim(positions, _, _), do: positions
end
