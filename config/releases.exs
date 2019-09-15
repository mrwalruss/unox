import Config

config :unox, UnoxWeb.Endpoint,
  http: [:inet6],
  url: [host: System.get_env("APP_HOST") || "localhost", port: 443, scheme: "https"],
  secret_key_base: System.fetch_env!("SECRET_KEY_BASE"),
  cache_static_manifest: "priv/static/cache_manifest.json",
  live_view: [
    signing_salt: System.fetch_env!("LIVE_VIEW_SIGNING_SALT")
  ],
  server: true

config :logger, level: :info

