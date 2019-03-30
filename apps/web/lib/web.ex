defmodule Web do
  @moduledoc false
  require EEx
  import Plug.Conn

  def add_url(conn) do
    case Core.Public.add_url(conn.params["url"]) do
      {:ok, url_map} ->
        conn |> send_success_resp(url_map)

      {:error, message} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(
             400,
             Poison.encode!(%{"error_message" => message})
           )
    end
  end

  def redirect_or_404(conn, hash) do
    case Core.Public.get_by_hash(hash) do
      {:ok, url_map} ->
        go_to_url(conn, url_map.destination)

      {:error, _} ->
        send_resp(conn, 404, "not found")
    end
  end

  def go_to_url(conn, url) do
    conn
    |> put_resp_content_type("text/plain")
    |> redirect(external: url)
    |> halt
  end

  defp redirect(conn, opts) when is_list(opts) do
    # https://github.com/phoenixframework/phoenix/blob/master/lib/phoenix/controller.ex#L392
    url = opts[:external]
    html = Plug.HTML.html_escape(url)
    body = "<html><body>You are being <a href=\"#{html}\">redirected</a>.</body></html>"

    conn
    |> put_resp_header("location", url)
    |> send_resp(conn.status || 302, body)
  end

  def render_homepage(conn) do
    conn
    |> put_resp_header("content-type", "text/html; charset=utf-8")
    |> Plug.Conn.send_file(200, Application.app_dir(:web, "/priv/static/index.html"))
  end

  defp send_success_resp(conn, url_map) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(
      200,
      Poison.encode!(%{"short_url" => build_short_url(url_map.hash)})
    )
  end

  defp build_short_url(hash) do
    base_url = Confex.get_env(:web, :base_url)

    unless base_url do
      raise "set WEB_BASE_URL environment variable!"
    end

    "#{base_url}/#{hash}"
  end
end
