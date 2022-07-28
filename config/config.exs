# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :haz_cash, :env, Mix.env()

config :haz_cash,
  ecto_repos: [HazCash.Repo],
  generators: [binary_id: true]

config :haz_cash, HazCash.Repo,
  migration_primary_key: [name: :id, type: :binary_id]

config :haz_cash,
  require_user_confirmation: true,
  require_subscription: true,  app_name: "HazCash",
  page_url: "haz_cash.com",
  company_name: "HazCash Inc",
  company_address: "26955 Fritsch Bridge",
  company_zip: "54933-7180",
  company_city: "San Fransisco",
  company_state: "California",
  company_country: "United States",
  contact_name: "John Doe",
  contact_phone: "+1 (335) 555-2036",
  contact_email: "john.doe@haz_cash.com",
  from_email: "john.doe@haz_cash.com"

# Configures the endpoint
config :haz_cash, HazCashWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: HazCashWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: HazCash.PubSub,
  live_view: [signing_salt: "lnh3B61C"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :haz_cash, HazCash.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.29",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :tailwind,
  version: "3.0.24",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :haz_cash, HazCash.Users.Guardian,
  issuer: "haz_cash",
  secret_key: System.get_env("GUARDIAN_SECRET_KEY_ADMINS") || "2gUyLN77NfzVyyJqS1JVJJAmC2Ya6/xwMUjEHrR+0LmTZPw/7c4gM2hvO/lYrBTs"

config :haz_cash, HazCash.Admins.Guardian,
  issuer: "haz_cash",
  secret_key: System.get_env("GUARDIAN_SECRET_KEY_ADMINS") || "byRKdM1WFopllqJ9Qac8mCeg2b8+WOqSnBJMGBO8sevkI7zH/dLWY9Y6W/vzJix1"

config :haz_cash, Oban,
  repo: HazCash.Repo,
  queues: [default: 10, mailers: 20, high: 50, low: 5],
  plugins: [
    {Oban.Plugins.Pruner, max_age: (3600 * 24)},
    {Oban.Plugins.Cron,
      crontab: [
       # {"0 2 * * *", HazCash.Workers.DailyDigestWorker},
       # {"@reboot", HazCash.Workers.StripeSyncWorker}
     ]}
  ]

config :saas_kit,
  admin: true,
  api_key: System.get_env("SAAS_KIT_API_KEY")

config :stripity_stripe,
  api_key: System.get_env("STRIPE_SECRET"),
  public_key: System.get_env("STRIPE_PUBLIC"),
  webhook_signing_key: System.get_env("STRIPE_WEBHOOK_SIGNING_KEY")
config :fun_with_flags, :persistence,
  adapter: FunWithFlags.Store.Persistent.Ecto,
  repo: HazCash.Repo

config :fun_with_flags, :cache_bust_notifications,
  enabled: true,
  adapter: FunWithFlags.Notifications.PhoenixPubSub,
  client: HazCash.PubSub

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
