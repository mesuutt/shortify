defmodule Core.URL do
  use Ecto.Schema
  import Ecto.Changeset

  # import only Ecto.Query.from/2
  import Ecto.Query # , only: [from: 2]

  alias Core.Ecto.HashId
  alias Core.Repo

  @primary_key {:hash, HashId, [autogenerate: true]}
  schema "urls" do
    field :url, :string

    timestamps()
  end

  def changeset(url, params \\ :empty) do
    url
    |> cast(params, [:url, :hash])
    |> validate_required([:url])
  end

  def add(url, hash \\ nil) do
    url =
      %Core.URL{}
      |> Core.URL.changeset(%{url: url, hash: hash})
      |> Repo.insert!()
  end

  def get(hash) do
    Repo.get_by(Core.URL, hash: "#{hash}")
    # Repo.get!(Api.Link, q)
  end
end
