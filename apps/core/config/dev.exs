use Mix.Config

# config :core, Core.Repo,
#       url: System.get_env("DATABASE_URL")

config :web, base_url: {:system, "WEB_BASE_URL", "localhost:4000"}
