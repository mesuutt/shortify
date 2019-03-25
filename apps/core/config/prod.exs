use Mix.Config

config :core, Core.Repo,
       # Replacing when building release with distillery: REPLACE_ENV_VARS
       url: "${DATABASE_URL}",
       pool_size: 10


config :web, base_url: {:system, "WEB_BASE_URL", "curl.ist"}
