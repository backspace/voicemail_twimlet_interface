# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :voicemail_twimlet_interface, VoicemailTwimletInterface.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ns/58n34hMX5AAxshiCxnSKblEJaGjT8rqxr5VLfQ4qoRMqrBKZCdGXftlKzzLDi",
  render_errors: [view: VoicemailTwimletInterface.ErrorView, accepts: ~w(html json)],
  pubsub: [name: VoicemailTwimletInterface.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :ex_twilio, account_sid: System.get_env("TWILIO_ACCOUNT_SID"),
                   auth_token: System.get_env("TWILIO_AUTH_TOKEN")

config :voicemail_twimlet_interface, :basic_auth, [
  realm: "Admin Area",
  username: "admin",
  password: "password"
]

config :voicemail_twimlet_interface,
  number_sid: System.get_env("TWILIO_NUMBER_SID")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
