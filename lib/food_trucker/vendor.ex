defmodule FoodTrucker.Vendor do
  @moduledoc """
  The Vendor context.
  """

  import Ecto.Query, warn: false

  alias FoodTrucker.Repo

  alias FoodTrucker.Vendor.FoodTruck
  alias FoodTrucker.Vendor.Location
  alias FoodTrucker.Vendor.OperatingHour

  @doc """
  Returns the list of food_trucks.

  ## Examples

      iex> list_food_trucks()
      [%FoodTruck{}, ...]

  """
  def list_food_trucks do
    Repo.all(FoodTruck)
  end

  @doc """
  Gets a single food_truck.

  Raises `Ecto.NoResultsError` if the Food truck does not exist.

  ## Examples

      iex> get_food_truck!(123)
      %FoodTruck{}

      iex> get_food_truck!(456)
      ** (Ecto.NoResultsError)

  """
  def get_food_truck!(id), do: Repo.get!(FoodTruck, id)

  @doc """
  Fetches a single food_truck from the query.
  Returns `nil` if no result was found. Raises if more than one entry.
  """
  def get_food_truck_by_permit(nil), do: nil

  def get_food_truck_by_permit(permit) do
    Repo.get_by(FoodTruck, permit: permit)
  end

  @doc """
  Creates a food_truck.

  ## Examples

      iex> create_food_truck(%{field: value})
      {:ok, %FoodTruck{}}

      iex> create_food_truck(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_food_truck(attrs \\ %{}) do
    %FoodTruck{}
    |> FoodTruck.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a food_truck.

  ## Examples

      iex> update_food_truck(food_truck, %{field: new_value})
      {:ok, %FoodTruck{}}

      iex> update_food_truck(food_truck, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_food_truck(%FoodTruck{} = food_truck, attrs) do
    food_truck
    |> FoodTruck.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a food_truck.

  ## Examples

      iex> delete_food_truck(food_truck)
      {:ok, %FoodTruck{}}

      iex> delete_food_truck(food_truck)
      {:error, %Ecto.Changeset{}}

  """
  def delete_food_truck(%FoodTruck{} = food_truck) do
    Repo.delete(food_truck)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking food_truck changes.

  ## Examples

      iex> change_food_truck(food_truck)
      %Ecto.Changeset{data: %FoodTruck{}}

  """
  def change_food_truck(%FoodTruck{} = food_truck, attrs \\ %{}) do
    FoodTruck.changeset(food_truck, attrs)
  end

  @doc """
  Returns the list of locations.

  ## Examples

      iex> list_locations()
      [%Location{}, ...]

  """
  def list_locations do
    Repo.all(Location)
  end

  @doc """
  Gets a single location.

  Raises `Ecto.NoResultsError` if the Location does not exist.

  ## Examples

      iex> get_location!(123)
      %Location{}

      iex> get_location!(456)
      ** (Ecto.NoResultsError)

  """
  def get_location!(id), do: Repo.get!(Location, id)

  @doc """
  Fetches a single location that belongs to a food_truck from the query.
  Returns `nil` if no result was found. Raises if more than one entry.
  """
  def get_food_truck_location(%{food_truck_id: id, lat: lat, lng: lng}) do
    from(location in Location,
      where: location.food_truck_id == ^id,
      where: location.latitude == ^lat,
      where: location.longitude == ^lng
    )
    |> Repo.one()
  end

  @doc """
  Creates a location.

  ## Examples

      iex> create_location(%{field: value})
      {:ok, %Location{}}

      iex> create_location(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_location(attrs \\ %{}) do
    %Location{}
    |> Location.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a location.

  ## Examples

      iex> update_location(location, %{field: new_value})
      {:ok, %Location{}}

      iex> update_location(location, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_location(%Location{} = location, attrs) do
    location
    |> Location.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a location.

  ## Examples

      iex> delete_location(location)
      {:ok, %Location{}}

      iex> delete_location(location)
      {:error, %Ecto.Changeset{}}

  """
  def delete_location(%Location{} = location) do
    Repo.delete(location)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking location changes.

  ## Examples

      iex> change_location(location)
      %Ecto.Changeset{data: %Location{}}

  """
  def change_location(%Location{} = location, attrs \\ %{}) do
    Location.changeset(location, attrs)
  end

  @doc """
  Returns the list of operating_hours.

  ## Examples

      iex> list_operating_hours()
      [%OperatingHour{}, ...]

  """
  def list_operating_hours do
    Repo.all(OperatingHour)
  end

  @doc """
  Gets a single operating_hour.

  Raises `Ecto.NoResultsError` if the Operating hour does not exist.

  ## Examples

      iex> get_operating_hour!(123)
      %OperatingHour{}

      iex> get_operating_hour!(456)
      ** (Ecto.NoResultsError)

  """
  def get_operating_hour!(id), do: Repo.get!(OperatingHour, id)

  @doc """
  Fetches a single operating_hour that belongs to a location from the query.
  Returns `nil` if no result was found. Raises if more than one entry.
  """
  def get_location_operating_hour(%{location_id: id, day_of_week: day}) do
    from(operating_hour in OperatingHour,
      where: operating_hour.location_id == ^id,
      where: operating_hour.day_of_week == ^day
    )
    |> Repo.one()
  end

  @doc """
  Creates a operating_hour.

  ## Examples

      iex> create_operating_hour(%{field: value})
      {:ok, %OperatingHour{}}

      iex> create_operating_hour(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_operating_hour(attrs \\ %{}) do
    %OperatingHour{}
    |> OperatingHour.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a operating_hour.

  ## Examples

      iex> update_operating_hour(operating_hour, %{field: new_value})
      {:ok, %OperatingHour{}}

      iex> update_operating_hour(operating_hour, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_operating_hour(%OperatingHour{} = operating_hour, attrs) do
    operating_hour
    |> OperatingHour.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a operating_hour.

  ## Examples

      iex> delete_operating_hour(operating_hour)
      {:ok, %OperatingHour{}}

      iex> delete_operating_hour(operating_hour)
      {:error, %Ecto.Changeset{}}

  """
  def delete_operating_hour(%OperatingHour{} = operating_hour) do
    Repo.delete(operating_hour)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking operating_hour changes.

  ## Examples

      iex> change_operating_hour(operating_hour)
      %Ecto.Changeset{data: %OperatingHour{}}

  """
  def change_operating_hour(%OperatingHour{} = operating_hour, attrs \\ %{}) do
    OperatingHour.changeset(operating_hour, attrs)
  end
end
