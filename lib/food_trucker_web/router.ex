defmodule FoodTruckerWeb.Router do
  use FoodTruckerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {FoodTruckerWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", FoodTruckerWeb do
    pipe_through :browser

    get "/", PageController, :home

    live "/food_trucks", FoodTruckLive.Index, :index
    live "/food_trucks/new", FoodTruckLive.Index, :new
    live "/food_trucks/:id/edit", FoodTruckLive.Index, :edit

    live "/food_trucks/:id", FoodTruckLive.Show, :show
    live "/food_trucks/:id/show/edit", FoodTruckLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", FoodTruckerWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:food_trucker, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: FoodTruckerWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
