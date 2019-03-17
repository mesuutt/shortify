defmodule Web do
  @moduledoc false

  import Plug.Conn

  def redirect_or_404(conn, hash) do
    link = Core.Public.get_url(hash)
    IO.inspect(link)

    case link do
      %{url: url} -> go_to_url(conn, url)
      nil -> send_resp(conn, 404, "Not found")
    end
  end

  def go_to_url(conn, url) do
    conn
    |> put_resp_content_type("text/plain")
    |> redirect(external: url)
    |> halt
  end

  def render_homepage(conn) do
    conn
    |> send_resp(200, "Main page")
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
end
