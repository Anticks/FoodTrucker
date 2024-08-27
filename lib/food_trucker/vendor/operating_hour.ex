defmodule FoodTrucker.Vendor.OperatingHour do
  use Ecto.Schema
  import Ecto.Changeset

  @day_values [:sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday]

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "operating_hours" do
    field :day_of_week, Ecto.Enum, values: @day_values
    field :start_time, :time
    field :end_time, :time

    timestamps(type: :utc_datetime)

    belongs_to(:location, FoodTrucker.Vendor.Location, references: :id, type: :binary_id)
  end

  @doc false
  def changeset(operating_hour, attrs) do
    operating_hour
    |> cast(attrs, [:day_of_week, :start_time, :end_time, :location_id])
    |> validate_required([:day_of_week, :start_time, :end_time, :location_id])
  end
end
