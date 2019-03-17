defmodule Web.Router do
  # use Plug.Builder
  use Plug.Router
  use Application

  plug(Plug.Logger)
  plug(Plug.Static,
    at: "/static",
    from: {:web, "/priv/static"}
  )
  plug(:match)
  plug(:dispatch)
  plug(:not_found)

  get "/:hash" do
    Web.redirect_or_404(conn, hash)
  end

  get "/" do
    conn
    |> put_resp_header("content-type", "text/html; charset=utf-8")
    |> Plug.Conn.send_file(200, Application.app_dir(:web, "/priv/static/index.html"))
  end

  def not_found(conn, _) do
    send_resp(conn, 404, "Not Found")
  end
end
