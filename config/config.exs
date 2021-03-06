# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :servantex,
  ecto_repos: [Servantex.Repo]

# Configures the endpoint
config :servantex, ServantexWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "D0snKTztDgrXyAqHSRUROAZfVKogkAxXJ+IbMCwh1z8BRbtb/VPISuJJRXTFsdJQ",
  render_errors: [view: ServantexWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Servantex.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :servantex,
  command_trait: %{
    "action.devices.commands.OnOff" => "action.devices.traits.OnOff",
    "action.devices.commands.BrightnessAbsolute" => "action.devices.traits.Brightness",
    "action.devices.commands.SetFanSpeed" => "action.devices.traits.FanSpeed",
    "action.devices.commands.Reverse" => "action.devices.traits.FanSpeed"
  }

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
