defmodule VersesOnDemand.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      VersesOnDemandWeb.Telemetry,
      VersesOnDemand.Repo,
      {DNSCluster, query: Application.get_env(:verses_on_demand, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: VersesOnDemand.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: VersesOnDemand.Finch},
      # Start a worker by calling: VersesOnDemand.Worker.start_link(arg)
      # {VersesOnDemand.Worker, arg},
      # Start to serve requests, typically the last entry
      VersesOnDemandWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: VersesOnDemand.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    VersesOnDemandWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
