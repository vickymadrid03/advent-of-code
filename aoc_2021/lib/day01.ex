defmodule Aoc.Day01 do
  @spec puzzle1(String.t()) :: integer()
  def puzzle1(input) do
    input
    |> String.split()
    |> Enum.map(&String.to_integer(&1))
    |> count_increases()
  end

  @spec puzzle2(String.t(), integer()) :: integer()
  def puzzle2(input, window_size \\ 3) do
    input
    |> String.split()
    |> Enum.map(&String.to_integer(&1))
    |> Enum.chunk_every(window_size, 1, :discard)
    |> Enum.map(&Enum.sum(&1))
    |> count_increases()
  end

  defp count_increases([]), do: 0

  defp count_increases([value1 | tail]) do
    do_count_increases(value1, tail, 0)
  end

  defp do_count_increases(_prev_value, [], count), do: count

  defp do_count_increases(prev_value, [value | tail], count) do
    new_count = if value > prev_value, do: count + 1, else: count

    do_count_increases(value, tail, new_count)
  end
end
