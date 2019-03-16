defmodule Api do
  import Plug.Conn

  def add_url(conn) do
    case CorePublic.add_url(conn.params["url"], conn.params["hash"]) do
      {:ok, changeset} ->
        scheme = Atom.to_string(conn.scheme)
        host = conn.host
        port = Integer.to_string(conn.port)
        hash = Map.get(changeset, :hash)

        url = "#{scheme}://#{host}:#{port}/#{hash}"

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Poison.encode!(%{"url" => url, "hash" => hash}))

      {:error, changeset} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(400, Poison.encode!(%{"error_message" => "URL with this name already exist"}))
    end
  end
end
