defmodule Core.Public do
  def add_url(url, hash \\ nil) do
    case Core.URL.get_by_destination(url) do
      nil ->
        case Core.URL.add(url, hash) do
          {:ok, changeset} ->
            changeset
            |> Map.from_struct()
            |> Map.take(Core.URL.__schema__(:fields))
            |> ok_tuple

          {:error, _} ->
            {:error, "Error while adding url"}
        end

      record ->
        record
        |> Map.from_struct()
        |> Map.take(Core.URL.__schema__(:fields))
        |> ok_tuple
    end
  end

  def get_by_hash(hash) do
    case Core.URL.get_by_hash(hash) do
      nil ->
        {:error, "Error while getting url"}

      changeset ->
        changeset
        |> Map.from_struct()
        |> Map.take(Core.URL.__schema__(:fields))
        |> ok_tuple
    end
  end

  defp ok_tuple(data), do: {:ok, data}
end
