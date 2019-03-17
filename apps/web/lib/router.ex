defmodule Web.Router do
  # use Plug.Builder
  use Plug.Router

  plug(Plug.Logger)

  plug(Plug.Static,
    at: "/static",
    from: {:web, "/priv/static"}
  )
  plug(Plug.Parsers, parsers: [:json, :urlencoded], json_decoder: Poison)

  plug(:match)
  plug(:dispatch)

  get "/:hash" do
    Web.redirect_or_404(conn, hash)
  end

  get "/" do
    Web.render_homepage(conn)
  end

  post "/urls" do
    Web.add_url(conn)
  end

  match _ do
    conn |> send_resp(400, "")
  end
end
