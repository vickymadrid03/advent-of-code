defmodule Aoc.Day04 do
  def puzzle1(input) do
    {drawn_numbers, boards} = parse_input(input)

    {winner, number} = play_bingo(drawn_numbers, boards)

    calculate_score(winner, number)
  end

  # No winner board
  defp play_bingo([], _boards), do: {nil, 0}

  defp play_bingo([number | numbers], boards) do
    marked_boards = Enum.map(boards, & mark_board(&1, number))
    maybe_find_winner?(marked_boards)
    |> case do
      nil -> play_bingo(numbers, marked_boards)
      board -> {board, String.to_integer(number)}
    end
  end

  def puzzle2(input) do
    {drawn_numbers, boards} = parse_input(input)

    {last_winner, number} = find_last_winner(drawn_numbers, boards)

    calculate_score(last_winner, number)
  end

  defp find_last_winner(numbers, boards, last_winner_data \\ {nil, 0})

  defp find_last_winner([], _boards, last_winner_data), do: last_winner_data

  defp find_last_winner([number | numbers], boards, last_winner_data) do
    marked_boards = Enum.map(boards, & mark_board(&1, number))
    winners = find_winners(marked_boards)

    if winners == [] do
      find_last_winner(numbers, marked_boards, last_winner_data)
    else
      remaining_boards = Enum.reject(marked_boards, & Enum.member?(winners, &1))
      last_winner = List.last(winners)

      find_last_winner(numbers, remaining_boards, {last_winner, String.to_integer(number)})
    end
  end

  defp calculate_score(nil, _number), do: 0

  defp calculate_score({board, marked}, number) do
    unmarked_sum(board, marked) * number
  end

  defp unmarked_sum(board, marked) do
    flattened_board = List.flatten(board)
    flattened_marked = List.flatten(marked)

    Enum.zip(flattened_board, flattened_marked)
    |> Enum.reduce(0, fn {value, mark}, sum ->
      if mark, do: sum, else: sum + String.to_integer(value)
    end)
  end

  defp mark_board({board, marking_board}, number) do
    Enum.with_index(board)
    |> Enum.reduce_while({board, marking_board}, fn {row, row_idx}, {board, marking_board} ->
      column_idx = Enum.find_index(row, & &1 == number)

      if column_idx do
        marked_row =
          marking_board
          |> Enum.at(row_idx)
          |> List.replace_at(column_idx, true)
        marked_board = List.replace_at(marking_board, row_idx, marked_row)

        {:halt, {board, marked_board}}
      else
        {:cont, {board, marking_board}}
      end
    end)
  end

  defp find_winners(boards) do
    Enum.filter(boards, fn {_board, marked_board} -> winner?(marked_board) end)
  end

  defp maybe_find_winner?(boards) do
    Enum.find(boards, fn {_board, marked_board} -> winner?(marked_board) end)
  end

  defp winner?(marked_board) do
    any_winner_row?(marked_board) || any_winner_column?(marked_board)
  end

  defp any_winner_row?(rows) do
    Enum.any?(rows, fn row -> Enum.all?(row) end)
  end

  def any_winner_column?(rows) do
    Enum.zip_with(rows, & &1)
    |> any_winner_row?()
  end

  defp parse_input(input) do
    [drawn_numbers | boards_list] = String.split(input, "\n")

    boards =
      boards_list
      |> Enum.chunk_by(& &1 == "")
      |> Enum.reject(& &1 == [""])
      |> Enum.map(fn board ->
        splitted_board = Enum.map(board, fn row -> String.split(row) end)
        empty_board = List.duplicate(false, 5) |> List.duplicate(5)

        {splitted_board, empty_board}
      end)

    {String.split(drawn_numbers, ","), boards}
  end
end
