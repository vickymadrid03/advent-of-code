defmodule Aoc.Day03 do
  # Power consumption
  def puzzle1(input) do
    [gamma_rate, epsilon_rate] =
      input
      |> String.split()
      |> Enum.map(&String.codepoints(&1))
      # Transpose matrix
      |> Enum.zip_with(& &1)
      |> Enum.map(fn bits ->
        %{"0" => freq_0, "1" => freq_1} = Enum.frequencies(bits)
        if freq_0 > freq_1, do: ["0", "1"], else: ["1", "0"]
      end)
      |> Enum.zip_with(& &1)
      |> Enum.map(fn bits ->
        {decimal_value, _rem} = Integer.parse(Enum.join(bits), 2)

        decimal_value
      end)

    gamma_rate * epsilon_rate
  end

  def puzzle2(input) do
    numbers_bits =
      input
      |> String.split()
      |> Enum.map(&String.codepoints(&1))

    oxigen_generator_rating = rating(numbers_bits, & oxigen_generator_bit/2)
    co2_scrubber_rating = rating(numbers_bits, & co2_scrubber_bit/2)

    oxigen_generator_rating * co2_scrubber_rating
  end

  defp rating(numbers_bits, bit_chooser) do
    bit_count = length(numbers_bits)

    {decimal_value, _rem} =
      Enum.reduce_while(0..bit_count, numbers_bits, fn idx, remaining_numbers ->
        %{"0" => freq_0, "1" => freq_1} =
          remaining_numbers
          |> Enum.zip_with(& &1)
          |> Enum.at(idx)
          |> Enum.frequencies()

        bit = bit_chooser.(freq_0, freq_1)

        Enum.filter(remaining_numbers, &(Enum.at(&1, idx) == bit))
        |> case do
          [number] -> {:halt, number}
          filtered_numbers -> {:cont, filtered_numbers}
        end
      end)
      |> Enum.join()
      |> Integer.parse(2)

    decimal_value
  end

  defp oxigen_generator_bit(freq_0, freq_1), do: if(freq_0 > freq_1, do: "0", else: "1")

  defp co2_scrubber_bit(freq_0, freq_1), do: if(freq_1 < freq_0, do: "1", else: "0")
end
