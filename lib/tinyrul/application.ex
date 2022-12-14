defmodule Tinyrul.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Tinyrul.Repo,
      # Start the Telemetry supervisor
      TinyrulWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Tinyrul.PubSub},
      # Start the Endpoint (http/https)
      TinyrulWeb.Endpoint
      # Start a worker by calling: Tinyrul.Worker.start_link(arg)
      # {Tinyrul.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    spawn(Tinyrul.Deleter, :process, [])
    opts = [strategy: :one_for_one, name: Tinyrul.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TinyrulWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
