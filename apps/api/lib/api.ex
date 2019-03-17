defmodule Api do
  import Plug.Conn

  def add_url(conn) do
    case Core.Public.add_url(conn.params["url"], conn.params["hash"]) do
      {:ok, url_map} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Poison.encode!(%{
          "short_url" => build_short_url(conn, url_map),
          "hash" => url_map.hash,
          "destination" => url_map.url,
        }))

      {:error, changeset} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(
          400,
          Poison.encode!(%{"error_message" => "URL with this name already exist"})
        )
    end
  end

  defp build_short_url(conn, url_map) do
    scheme = Atom.to_string(conn.scheme)
    host = conn.host
    port = Integer.to_string(conn.port)
    hash = Map.get(url_map, :hash)

    "#{scheme}://#{host}:#{port}/#{hash}"
  end

end
