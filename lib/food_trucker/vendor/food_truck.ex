defmodule FoodTrucker.Vendor.FoodTruck do
  use Ecto.Schema
  import Ecto.Changeset

  @status_values [:requested, :expired, :approved, :suspend, :issued]
  @facility_values [:truck, :push_cart]

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "food_trucks" do
    field :name, :string
    field :permit, :string
    field :status, Ecto.Enum, values: @status_values
    field :food_item_description, :string
    field :facility_type, Ecto.Enum, values: @facility_values

    timestamps(type: :utc_datetime)

    has_many(:locations, FoodTrucker.Vendor.Location)
  end

  @doc false
  def changeset(food_truck, attrs) do
    food_truck
    |> cast(attrs, [:name, :food_item_description, :facility_type, :status, :permit])
    |> validate_required([:name, :status, :permit])
    |> unique_constraint(:permit)
  end
end
