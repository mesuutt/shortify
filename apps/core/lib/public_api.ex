defmodule Core.Public do
  def add_url(url, hash \\ nil) do
    case Core.URL.add(url, hash) do
      {:ok, changeset} ->
        changeset
        |> Map.from_struct()
        |> Map.take(Core.URL.__schema__(:fields))
        |> ok_tuple
      {:error, changeset} ->
        {:error, "Error while adding url"}
    end
  end

  def get_url(hash) do
    case Core.URL.get(hash) do
      nil -> {:error, "Error while getting url"}
      changeset ->
        changeset
        |> Map.from_struct()
        |> Map.take(Core.URL.__schema__(:fields))
        |> ok_tuple
    end
  end

  defp ok_tuple(data), do: {:ok, data}
end
