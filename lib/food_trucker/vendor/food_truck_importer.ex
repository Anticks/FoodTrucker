defmodule FoodTrucker.Vendor.FoodTruckImporter do
  @moduledoc """
  This module is responsible for collecting food truck data during the ingestion process of CSVs.
  This process is idempotent and will yield the same result if the CSV is unchanged.
  """

  require Logger

  alias FoodTrucker.Vendor.ParseOperatingHour
  alias NimbleCSV.RFC4180, as: CSV

  @module_name "FoodTrucker.Vendor.FoodTruckImporter"

  @row_name "Applicant"
  @row_status "Status"
  @row_food_item_description "FoodItems"
  @row_facility_type "FacilityType"
  @row_permit "permit"
  @row_lat "Latitude"
  @row_lng "Longitude"
  @row_address "Address"
  @row_location_description "LocationDescription"
  @row_operating_hours "dayshours"

  @spec ingest(binary()) :: {:ok, atom()}
  @doc """
  Given a file path to a food truck CSV, processes and ingests applicable data from the CSV,
  returning an :ok complete atom when done.
  """
  def ingest(file) do
    column_names = column_names(file)

    rows =
      file
      |> File.stream!()
      |> CSV.parse_stream(skip_headers: true)
      |> Enum.map(fn row ->
        row
        |> Enum.with_index()
        |> Map.new(fn {val, num} -> {column_names[num], val} end)
        |> process_food_truck()
      end)

    Logger.info("#{@module_name}: Processed #{length(rows)} Food Truck Rows")

    {:ok, :complete}
  end

  defp column_names(file) do
    file
    |> File.stream!()
    |> CSV.parse_stream(skip_headers: false)
    |> Enum.fetch!(0)
    |> Enum.with_index()
    |> Map.new(fn {val, num} -> {num, val} end)
  end

  defp process_food_truck(row) do
    with {:ok, food_truck} <- food_truck(row),
         {:ok, location} <- location(food_truck, row),
         _operating_hours <- operating_hours(location, row) do
      :ok
    end
  end

  defp food_truck(row) do
    row[@row_permit]
    |> FoodTrucker.Vendor.get_food_truck_by_permit()
    |> case do
      nil -> create_food_truck(row)
      food_truck -> {:ok, food_truck}
    end
  end

  defp create_food_truck(row) do
    FoodTrucker.Vendor.create_food_truck(%{
      name: row[@row_name],
      status: atomize_value(row[@row_status]),
      food_item_description: row[@row_food_item_description] |> String.slice(0..254),
      facility_type: atomize_value(row[@row_facility_type]),
      permit: row[@row_permit]
    })
    |> case do
      {:ok, food_truck} ->
        Logger.info(
          "#{@module_name}: Food truck created. ID: #{food_truck.id}, Name: #{food_truck.name}"
        )

        {:ok, food_truck}

      err ->
        Logger.error("#{@module_name}: Error creating food truck: #{inspect(err)}")
        {:error, :error_creating_food_truck}
    end
  end

  defp atomize_value(""), do: nil

  defp atomize_value(value) do
    value
    |> String.trim()
    |> String.replace(" ", "_")
    |> String.downcase()
    |> String.to_existing_atom()
  end

  defp location(food_truck, row) do
    FoodTrucker.Vendor.get_food_truck_location(%{
      food_truck_id: food_truck.id,
      lat: row[@row_lat],
      lng: row[@row_lng]
    })
    |> case do
      nil -> create_location(food_truck, row)
      location -> {:ok, location}
    end
  end

  defp create_location(food_truck, row) do
    FoodTrucker.Vendor.create_location(%{
      food_truck_id: food_truck.id,
      latitude: row[@row_lat],
      longitude: row[@row_lng],
      location_description: format_location_description(row)
    })
  end

  defp format_location_description(row) do
    "#{String.upcase(row[@row_address])} | #{String.upcase(row[@row_location_description])}"
    |> String.slice(0..254)
  end

  defp operating_hours(location, row) do
    for locate_operating_hours <- ParseOperatingHour.locate_times(row[@row_operating_hours]) do
      FoodTrucker.Vendor.get_location_operating_hour(%{
        location_id: location.id,
        day_of_week: locate_operating_hours.day_of_week
      })
      |> case do
        nil ->
          create_operating_hour(location, locate_operating_hours)

        operating_hour ->
          {:ok, operating_hour}
      end
    end
  end

  defp create_operating_hour(location, operating_hours) do
    operating_hours
    |> Map.merge(%{location_id: location.id})
    |> FoodTrucker.Vendor.create_operating_hour()
  end
end
