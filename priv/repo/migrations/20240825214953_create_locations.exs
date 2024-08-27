defmodule FoodTrucker.Repo.Migrations.CreateLocations do
  use Ecto.Migration

  def change do
    create table(:locations, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false
      add :food_truck_id, references(:food_trucks, type: :uuid), null: false
      add :latitude, :float
      add :longitude, :float
      add :location_description, :string

      timestamps(type: :utc_datetime)
    end
  end
end
