defmodule FoodTrucker.Repo.Migrations.CreateOperatingHours do
  use Ecto.Migration

  def change do
    create table(:operating_hours, primary_key: false) do
      add :id, :uuid, primary_key: true, null: false
      add :location_id, references(:locations, type: :uuid), null: false
      add :day_of_week, :string
      add :start_time, :time
      add :end_time, :time

      timestamps(type: :utc_datetime)
    end
  end
end
