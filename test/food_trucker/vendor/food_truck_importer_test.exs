defmodule FoodTrucker.Vendor.FoodTruckImporterTest do
  use FoodTrucker.DataCase

  import Ecto.Query, warn: false

  alias FoodTrucker.Vendor.FoodTruckImporter

  describe "importer" do
    test "only a single food truck is created for a given permit" do
      Code.ensure_compiled(FoodTrucker.Vendor.FoodTruck)

      assert {:ok, :complete} =
               FoodTruckImporter.ingest("test/food_trucker/vendor/foodtrucks_test.csv")

      assert %{
               name: "Spike and Faye",
               permit: "23MFF-00032",
               status: :approved,
               food_item_description: "Tacos: burritos: soda & juice",
               facility_type: :truck
             } =
               FoodTrucker.Repo.get_by!(FoodTrucker.Vendor.FoodTruck, name: "Spike and Faye")
    end

    test "multiple food truck locations are created for a given permit" do
      Code.ensure_compiled(FoodTrucker.Vendor.FoodTruck)

      assert {:ok, :complete} =
               FoodTruckImporter.ingest("test/food_trucker/vendor/foodtrucks_test.csv")

      %{id: food_truck_id} =
        FoodTrucker.Repo.get_by!(FoodTrucker.Vendor.FoodTruck, name: "Spike and Faye")

      assert [
               %{
                 latitude: 37.7509316476402,
                 longitude: -122.411419966206,
                 location_description:
                   "3065 25TH ST | 25TH ST: ALABAMA ST TO HARRISON ST (3042 - 3099)",
                 food_truck_id: ^food_truck_id
               },
               %{
                 latitude: 37.7715867026703,
                 longitude: -122.414007043024,
                 location_description:
                   "1501 FOLSOM ST | FOLSOM ST: 11TH ST TO NORFOLK ST (1500 - 1548)",
                 food_truck_id: ^food_truck_id
               }
             ] =
               from(location in FoodTrucker.Vendor.Location,
                 where: location.food_truck_id == ^food_truck_id
               )
               |> Repo.all()
    end

    test "multiple location operation hours are created for a given permit" do
      Code.ensure_compiled(FoodTrucker.Vendor.FoodTruck)

      assert {:ok, :complete} =
               FoodTruckImporter.ingest("test/food_trucker/vendor/foodtrucks_test.csv")

      %{id: food_truck_id} =
        FoodTrucker.Repo.get_by!(FoodTrucker.Vendor.FoodTruck, name: "Spike and Faye")

      [%{id: location_id_one}, %{id: location_id_two}] =
        from(location in FoodTrucker.Vendor.Location,
          where: location.food_truck_id == ^food_truck_id
        )
        |> Repo.all()

      assert [
               %{
                 day_of_week: :monday,
                 start_time: ~T[17:00:00],
                 end_time: ~T[18:00:00],
                 location_id: ^location_id_one
               },
               %{
                 day_of_week: :tuesday,
                 start_time: ~T[17:00:00],
                 end_time: ~T[18:00:00],
                 location_id: ^location_id_one
               },
               %{
                 day_of_week: :wednesday,
                 start_time: ~T[17:00:00],
                 end_time: ~T[18:00:00],
                 location_id: ^location_id_one
               },
               %{
                 day_of_week: :thursday,
                 start_time: ~T[17:00:00],
                 end_time: ~T[18:00:00],
                 location_id: ^location_id_one
               },
               %{
                 day_of_week: :friday,
                 start_time: ~T[17:00:00],
                 end_time: ~T[18:00:00],
                 location_id: ^location_id_one
               }
             ] =
               from(operating_hour in FoodTrucker.Vendor.OperatingHour,
                 where: operating_hour.location_id == ^location_id_one
               )
               |> Repo.all()

      assert [
               %{
                 day_of_week: :wednesday,
                 start_time: ~T[06:00:00],
                 end_time: ~T[18:00:00],
                 location_id: ^location_id_two
               },
               %{
                 day_of_week: :thursday,
                 start_time: ~T[06:00:00],
                 end_time: ~T[18:00:00],
                 location_id: ^location_id_two
               },
               %{
                 day_of_week: :friday,
                 start_time: ~T[06:00:00],
                 end_time: ~T[18:00:00],
                 location_id: ^location_id_two
               }
             ] =
               from(operating_hour in FoodTrucker.Vendor.OperatingHour,
                 where: operating_hour.location_id == ^location_id_two
               )
               |> Repo.all()
    end
  end
end
