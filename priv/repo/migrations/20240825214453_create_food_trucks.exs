defmodule FoodTrucker.Repo.Migrations.CreateFoodTrucks do
  use Ecto.Migration

  def change do
    create table(:food_trucks, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false
      add :name, :string
      add :food_item_description, :string
      add :facility_type, :string
      add :permit, :string
      add :status, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:food_trucks, [:permit])
  end
end
