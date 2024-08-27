defmodule FoodTrucker.VendorTest do
  use FoodTrucker.DataCase

  alias FoodTrucker.Vendor

  describe "food_trucks" do
    alias FoodTrucker.Vendor.FoodTruck

    import FoodTrucker.VendorFixtures

    @invalid_attrs %{
      name: nil,
      status: nil,
      food_item_description: nil,
      facility_type: nil,
      permit: nil
    }

    test "list_food_trucks/0 returns all food_trucks" do
      food_truck = food_truck_fixture()
      assert Vendor.list_food_trucks() == [food_truck]
    end

    test "get_food_truck!/1 returns the food_truck with given id" do
      food_truck = food_truck_fixture()
      assert Vendor.get_food_truck!(food_truck.id) == food_truck
    end

    test "create_food_truck/1 with valid data creates a food_truck" do
      valid_attrs = %{
        name: "some name",
        status: :approved,
        food_item_description: "some food_item_description",
        facility_type: :truck,
        permit: "some permit"
      }

      assert {:ok, %FoodTruck{} = food_truck} = Vendor.create_food_truck(valid_attrs)
      assert food_truck.name == "some name"
      assert food_truck.status == :approved
      assert food_truck.food_item_description == "some food_item_description"
      assert food_truck.facility_type == :truck
    end

    test "create_food_truck/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Vendor.create_food_truck(@invalid_attrs)
    end

    test "update_food_truck/2 with valid data updates the food_truck" do
      food_truck = food_truck_fixture()

      update_attrs = %{
        name: "some updated name",
        status: :requested,
        food_item_description: "some updated food_item_description",
        facility_type: :push_cart,
        permit: "some updated permit"
      }

      assert {:ok, %FoodTruck{} = food_truck} = Vendor.update_food_truck(food_truck, update_attrs)
      assert food_truck.name == "some updated name"
      assert food_truck.status == :requested
      assert food_truck.food_item_description == "some updated food_item_description"
      assert food_truck.facility_type == :push_cart
    end

    test "update_food_truck/2 with invalid data returns error changeset" do
      food_truck = food_truck_fixture()
      assert {:error, %Ecto.Changeset{}} = Vendor.update_food_truck(food_truck, @invalid_attrs)
      assert food_truck == Vendor.get_food_truck!(food_truck.id)
    end

    test "delete_food_truck/1 deletes the food_truck" do
      food_truck = food_truck_fixture()
      assert {:ok, %FoodTruck{}} = Vendor.delete_food_truck(food_truck)
      assert_raise Ecto.NoResultsError, fn -> Vendor.get_food_truck!(food_truck.id) end
    end

    test "change_food_truck/1 returns a food_truck changeset" do
      food_truck = food_truck_fixture()
      assert %Ecto.Changeset{} = Vendor.change_food_truck(food_truck)
    end
  end

  describe "locations" do
    alias FoodTrucker.Vendor.Location

    import FoodTrucker.VendorFixtures

    @invalid_attrs %{latitude: nil, longitude: nil, location_description: nil}

    test "list_locations/0 returns all locations" do
      location = location_fixture()
      assert Vendor.list_locations() == [location]
    end

    test "get_location!/1 returns the location with given id" do
      location = location_fixture()
      assert Vendor.get_location!(location.id) == location
    end

    test "create_location/1 with valid data creates a location" do
      food_truck = food_truck_fixture()

      valid_attrs = %{
        food_truck_id: food_truck.id,
        latitude: 100.00,
        longitude: 200.00,
        location_description: "some location_description"
      }

      assert {:ok, %Location{} = location} = Vendor.create_location(valid_attrs)
      assert location.latitude == 100.00
      assert location.longitude == 200.00
      assert location.location_description == "some location_description"
    end

    test "create_location/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Vendor.create_location(@invalid_attrs)
    end

    test "update_location/2 with valid data updates the location" do
      location = location_fixture()

      update_attrs = %{
        latitude: 300.00,
        longitude: 400.00,
        location_description: "some updated location_description"
      }

      assert {:ok, %Location{} = location} = Vendor.update_location(location, update_attrs)
      assert location.latitude == 300.00
      assert location.longitude == 400.00
      assert location.location_description == "some updated location_description"
    end

    test "update_location/2 with invalid data returns error changeset" do
      location = location_fixture()
      assert {:error, %Ecto.Changeset{}} = Vendor.update_location(location, @invalid_attrs)
      assert location == Vendor.get_location!(location.id)
    end

    test "delete_location/1 deletes the location" do
      location = location_fixture()
      assert {:ok, %Location{}} = Vendor.delete_location(location)
      assert_raise Ecto.NoResultsError, fn -> Vendor.get_location!(location.id) end
    end

    test "change_location/1 returns a location changeset" do
      location = location_fixture()
      assert %Ecto.Changeset{} = Vendor.change_location(location)
    end
  end

  describe "operating_hours" do
    alias FoodTrucker.Vendor.OperatingHour

    import FoodTrucker.VendorFixtures

    @invalid_attrs %{day_of_week: nil, start_time: nil, end_time: nil}

    test "list_operating_hours/0 returns all operating_hours" do
      operating_hour = operating_hour_fixture()
      assert Vendor.list_operating_hours() == [operating_hour]
    end

    test "get_operating_hour!/1 returns the operating_hour with given id" do
      operating_hour = operating_hour_fixture()
      assert Vendor.get_operating_hour!(operating_hour.id) == operating_hour
    end

    test "create_operating_hour/1 with valid data creates a operating_hour" do
      location = location_fixture()

      valid_attrs = %{
        location_id: location.id,
        day_of_week: :monday,
        start_time: ~T[01:00:00],
        end_time: ~T[12:00:00]
      }

      assert {:ok, %OperatingHour{} = operating_hour} = Vendor.create_operating_hour(valid_attrs)
      assert operating_hour.day_of_week == :monday
      assert operating_hour.start_time == ~T[01:00:00]
      assert operating_hour.end_time == ~T[12:00:00]
    end

    test "create_operating_hour/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Vendor.create_operating_hour(@invalid_attrs)
    end

    test "update_operating_hour/2 with valid data updates the operating_hour" do
      operating_hour = operating_hour_fixture()
      update_attrs = %{day_of_week: :tuesday, start_time: ~T[01:00:00], end_time: ~T[12:00:00]}

      assert {:ok, %OperatingHour{} = operating_hour} =
               Vendor.update_operating_hour(operating_hour, update_attrs)

      assert operating_hour.day_of_week == :tuesday
      assert operating_hour.start_time == ~T[01:00:00]
      assert operating_hour.end_time == ~T[12:00:00]
    end

    test "update_operating_hour/2 with invalid data returns error changeset" do
      operating_hour = operating_hour_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Vendor.update_operating_hour(operating_hour, @invalid_attrs)

      assert operating_hour == Vendor.get_operating_hour!(operating_hour.id)
    end

    test "delete_operating_hour/1 deletes the operating_hour" do
      operating_hour = operating_hour_fixture()
      assert {:ok, %OperatingHour{}} = Vendor.delete_operating_hour(operating_hour)
      assert_raise Ecto.NoResultsError, fn -> Vendor.get_operating_hour!(operating_hour.id) end
    end

    test "change_operating_hour/1 returns a operating_hour changeset" do
      operating_hour = operating_hour_fixture()
      assert %Ecto.Changeset{} = Vendor.change_operating_hour(operating_hour)
    end
  end
end
