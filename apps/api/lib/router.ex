defmodule Api.Router do
  use Plug.Router

  plug(Plug.Logger)
  # plug Plug.RequestId

  # Parsers plug must be before :match
  plug(Plug.Parsers, parsers: [:json, :urlencoded], json_decoder: Poison)
  plug(:match)
  plug(:dispatch)

  post "/urls" do
    Api.add_url(conn)
  end

  match _ do
    conn |> send_resp(400, "")
  end
end
