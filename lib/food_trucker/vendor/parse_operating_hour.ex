defmodule FoodTrucker.Vendor.ParseOperatingHour do
  @moduledoc """
  This module is responsible for parsing a given string from the ingestion CSV.
  """

  require Logger

  @day_number %{
    "Su" => 0,
    "Mo" => 1,
    "Tu" => 2,
    "We" => 3,
    "Th" => 4,
    "Fr" => 5,
    "Sa" => 6
  }

  @day_list [
    :sunday,
    :monday,
    :tuesday,
    :wednesday,
    :thursday,
    :friday,
    :saturday
  ]

  @spec locate_times(binary()) :: list()
  @doc """
  Parses a given string for these known formats:
  "Su-Fr:12AM-3AM" | "Th/Fr/Sa:10PM-12AM" | "Su-We:11PM-12AM;Fr/Sa:10PM-12AM" 
  Returns a list of operating hours that can be used for creation.
  """
  def locate_times(times) do
    cond do
      String.contains?(times, ";") ->
        multiple_times = String.split(times, ";")
        parse_multiple_times(multiple_times)

      String.contains?(times, ":") ->
        parse_times(times)

      true ->
        []
    end
  end

  defp parse_multiple_times(times) do
    Enum.map(times, fn time ->
      days_times = String.split(time, ":")
      days = Enum.at(days_times, 0)
      times = days_times |> Enum.at(1) |> times()

      cond do
        String.contains?(days, "-") ->
          operating_hours_days_through(days, times)

        String.contains?(days, "/") ->
          operating_hours_days(days, times)

        true ->
          []
      end
    end)
    |> List.flatten()
  end

  defp parse_times(times) do
    days_times = String.split(times, ":")
    days = Enum.at(days_times, 0)
    times = days_times |> Enum.at(1) |> times()

    cond do
      String.contains?(days, "-") ->
        operating_hours_days_through(days, times)

      String.contains?(days, "/") ->
        operating_hours_days(days, times)

      true ->
        []
    end
  end

  defp operating_hours_days(days, times) do
    days = String.split(days, "/")

    for day <- days do
      %{day_of_week: Enum.at(@day_list, @day_number[day])}
      |> Map.merge(times)
    end
  end

  defp operating_hours_days_through(days, times) do
    days = String.split(days, "-")

    for day <- @day_number[Enum.at(days, 0)]..@day_number[Enum.at(days, 1)] do
      %{day_of_week: Enum.at(@day_list, day)}
      |> Map.merge(times)
    end
  end

  defp times(times) do
    times = String.split(times, "-")

    %{
      start_time: times |> Enum.at(0) |> format_time(),
      end_time: times |> Enum.at(1) |> format_time()
    }
  end

  defp format_time(time) do
    time
    |> Timex.parse("{h12}{AM}")
    |> case do
      {:ok, native_time} -> Time.convert!(native_time, Calendar.ISO)
      {:error, _err} -> ~T[00:00:00]
    end
  end
end
