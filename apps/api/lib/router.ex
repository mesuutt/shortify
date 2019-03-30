defmodule Api.Router do
  use Plug.Router

  plug(Plug.Logger)

  # Parsers plug must be before :match
  plug(Plug.Parsers, parsers: [:json, :urlencoded], json_decoder: Poison)
  plug(:match)
  plug(:dispatch)

  post "/" do
    # This is a simple project, so we can post to root url.
    Api.add_url(conn)
  end

  match _ do
    conn |> send_resp(400, "")
  end
end
