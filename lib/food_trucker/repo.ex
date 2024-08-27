defmodule FoodTrucker.Repo do
  use Ecto.Repo,
    otp_app: :food_trucker,
    adapter: Ecto.Adapters.Postgres
end
