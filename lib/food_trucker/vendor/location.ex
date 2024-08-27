defmodule FoodTrucker.Vendor.Location do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "locations" do
    field :latitude, :float
    field :longitude, :float
    field :location_description, :string

    timestamps(type: :utc_datetime)

    belongs_to(:food_truck, FoodTrucker.Vendor.FoodTruck, references: :id, type: :binary_id)
    has_many(:operating_hours, FoodTrucker.Vendor.OperatingHour)
  end

  @doc false
  def changeset(location, attrs) do
    location
    |> cast(attrs, [:latitude, :longitude, :location_description, :food_truck_id])
    |> validate_required([:latitude, :longitude, :location_description, :food_truck_id])
  end
end
