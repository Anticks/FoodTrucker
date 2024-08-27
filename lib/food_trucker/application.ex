defmodule FoodTrucker.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      FoodTruckerWeb.Telemetry,
      FoodTrucker.Repo,
      {DNSCluster, query: Application.get_env(:food_trucker, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: FoodTrucker.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: FoodTrucker.Finch},
      # Start a worker by calling: FoodTrucker.Worker.start_link(arg)
      # {FoodTrucker.Worker, arg},
      # Start to serve requests, typically the last entry
      FoodTruckerWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FoodTrucker.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FoodTruckerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
