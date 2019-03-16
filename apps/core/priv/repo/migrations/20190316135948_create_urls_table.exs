defmodule Core.Repo.Migrations.CreateUrlsTable do
  use Ecto.Migration

  def change do
    create table(:urls) do
      add :hash, :string, primary_key: true
      add :url, :string, null: false

      timestamps()
    end

    # We didn't add unique index to url to allow each user to add same url with different unique hash.
    # create unique_index(:urls, [:url])
    create unique_index(:urls, [:hash])
  end

end
