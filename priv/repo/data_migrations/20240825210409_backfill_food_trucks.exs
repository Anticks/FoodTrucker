defmodule FoodTrucker.Repo.Migrations.BackfillFoodTrucks do
  use Ecto.Migration

  alias FoodTrucker.Vendor.FoodTruckImporter

  def up do
    FoodTruckImporter.ingest("priv/repo/data/foodtrucks.csv")
  end

  def down, do: :ok
end
