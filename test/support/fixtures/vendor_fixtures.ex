defmodule FoodTrucker.VendorFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `FoodTrucker.Vendor` context.
  """

  @doc """
  Generate a food_truck.
  """
  def food_truck_fixture(attrs \\ %{}) do
    {:ok, food_truck} =
      attrs
      |> Enum.into(%{
        facility_type: :truck,
        food_item_description: "some food_item_description",
        name: "some name",
        status: :approved,
        permit: "some permit"
      })
      |> FoodTrucker.Vendor.create_food_truck()

    food_truck
  end

  @doc """
  Generate a location.
  """
  def location_fixture(attrs \\ %{}) do
    {:ok, food_truck} =
      attrs
      |> Enum.into(%{
        facility_type: :truck,
        food_item_description: "some food_item_description",
        name: "some name",
        status: :approved,
        permit: "some permit"
      })
      |> FoodTrucker.Vendor.create_food_truck()

    {:ok, location} =
      attrs
      |> Enum.into(%{
        food_truck_id: food_truck.id,
        latitude: 100.00,
        location_description: "some location_description",
        longitude: 200.00
      })
      |> FoodTrucker.Vendor.create_location()

    location
  end

  @doc """
  Generate a operating_hour.
  """
  def operating_hour_fixture(attrs \\ %{}) do
    {:ok, food_truck} =
      attrs
      |> Enum.into(%{
        facility_type: :truck,
        food_item_description: "some food_item_description",
        name: "some name",
        status: :approved,
        permit: "some permit"
      })
      |> FoodTrucker.Vendor.create_food_truck()

    {:ok, location} =
      attrs
      |> Enum.into(%{
        food_truck_id: food_truck.id,
        latitude: 100.00,
        location_description: "some location_description",
        longitude: 200.00
      })
      |> FoodTrucker.Vendor.create_location()

    {:ok, operating_hour} =
      attrs
      |> Enum.into(%{
        location_id: location.id,
        day_of_week: :monday,
        end_time: ~T[12:00:00],
        start_time: ~T[01:00:00]
      })
      |> FoodTrucker.Vendor.create_operating_hour()

    operating_hour
  end
end
