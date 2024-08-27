defmodule FoodTrucker.Vendor.ParseOperatingHourTest do
  use FoodTrucker.DataCase

  alias FoodTrucker.Vendor.ParseOperatingHour

  describe "locate_times/1" do
    test "Sunday through Friday 12am through 3am is returned" do
      assert [
               %{start_time: ~T[00:00:00], day_of_week: :sunday, end_time: ~T[03:00:00]},
               %{start_time: ~T[00:00:00], day_of_week: :monday, end_time: ~T[03:00:00]},
               %{start_time: ~T[00:00:00], day_of_week: :tuesday, end_time: ~T[03:00:00]},
               %{start_time: ~T[00:00:00], day_of_week: :wednesday, end_time: ~T[03:00:00]},
               %{start_time: ~T[00:00:00], day_of_week: :thursday, end_time: ~T[03:00:00]},
               %{start_time: ~T[00:00:00], day_of_week: :friday, end_time: ~T[03:00:00]}
             ] =
               ParseOperatingHour.locate_times("Su-Fr:12AM-3AM")
    end

    test "Thursday, Friday, Saturday 10pm through 12am is returned" do
      assert [
               %{day_of_week: :thursday, end_time: ~T[00:00:00], start_time: ~T[22:00:00]},
               %{day_of_week: :friday, end_time: ~T[00:00:00], start_time: ~T[22:00:00]},
               %{day_of_week: :saturday, end_time: ~T[00:00:00], start_time: ~T[22:00:00]}
             ] =
               ParseOperatingHour.locate_times("Th/Fr/Sa:10PM-12AM")
    end

    test "Friday, Saturday and Mon through Wednesday is returned" do
      assert [
               %{day_of_week: :sunday, end_time: ~T[00:00:00], start_time: ~T[23:00:00]},
               %{day_of_week: :monday, end_time: ~T[00:00:00], start_time: ~T[23:00:00]},
               %{day_of_week: :tuesday, end_time: ~T[00:00:00], start_time: ~T[23:00:00]},
               %{day_of_week: :wednesday, end_time: ~T[00:00:00], start_time: ~T[23:00:00]},
               %{day_of_week: :friday, end_time: ~T[00:00:00], start_time: ~T[22:00:00]},
               %{day_of_week: :saturday, end_time: ~T[00:00:00], start_time: ~T[22:00:00]}
             ] =
               ParseOperatingHour.locate_times("Su-We:11PM-12AM;Fr/Sa:10PM-12AM")
    end

    test "An empty list is returned when no matches are found" do
      assert [] =
               ParseOperatingHour.locate_times(":")
    end
  end
end
