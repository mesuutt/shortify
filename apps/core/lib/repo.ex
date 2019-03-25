defmodule Core.Repo do
  use Ecto.Repo,
    otp_app: :core,
    adapter: Ecto.Adapters.Postgres

  def init(_type, config) do
    # Reading DATABASE_URL on application start
    url = System.get_env("DATABASE_URL")

    unless url do
      raise "set DATABASE_URL environment variable!"
    end

    if url, do: {:ok, [url: url] ++ config}, else: {:ok, config}
  end
end
