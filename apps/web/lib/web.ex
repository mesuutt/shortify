defmodule Web do
  @moduledoc false
  require EEx
  import Plug.Conn

  def redirect_or_404(conn, hash) do
    case Core.Public.get_url(hash) do
      {:ok, url_map} ->
        go_to_url(conn, url_map.url)
      {:error, _}-> send_resp(conn, 404, "not found")
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
    template = Web.main_page_html(conn.assigns)
    # template_file = Application.app_dir(:web, "/priv/static/index.html")
    conn
    |> put_resp_header("content-type", "text/html; charset=utf-8")
    |> Plug.Conn.send_resp(200, template)
  end

  EEx.function_from_file(:def, :main_page_html, "lib/templates/index.eex", [:assigns])

  defp template_context do
    %{
      api_url: "http://localhost:3031/urls"
    }
  end

  def add_url(conn) do
    case Core.Public.add_url(conn.params["url"]) do
      {:ok, url_map} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(
             200,
             Poison.encode!(%{"short_url" => build_short_url(conn, url_map)})
           )
      {:error, message} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(
             400,
             Poison.encode!(%{"error_message" => message})
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