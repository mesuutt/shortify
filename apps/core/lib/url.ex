defmodule Core.URL do
  use Ecto.Schema
  import Ecto.Changeset

  alias Core.Ecto.HashId
  alias Core.Repo

  @primary_key {:hash, HashId, [autogenerate: true]}
  schema "urls" do
    field(:destination, :string)
    timestamps()
  end

  def changeset(destination, params \\ :empty) do
    destination
    |> cast(params, [:destination, :hash])
    |> validate_required([:destination])
    |> unique_constraint(:hash)
  end

  def add(destination, hash \\ nil) do
    %Core.URL{}
    |> Core.URL.changeset(%{destination: destination, hash: hash})
    |> Repo.insert()
  end

  def get_by_hash(hash) do
    Repo.get_by(Core.URL, hash: "#{hash}")
  end

end
