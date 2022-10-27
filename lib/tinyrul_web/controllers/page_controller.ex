defmodule TinyrulWeb.PageController do
  use TinyrulWeb, :controller

  import Tinyrul.{UrlService, Repository.Url}

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def url(conn, params) do
    original_url = params["original_url"]
    random_key = generate_short_url(conn.host, conn.port)

    case insert(original_url, random_key) do
      {:ok, _inserted} ->
        conn
        |> send_resp(201, random_key)

      {:error, reason} ->
        conn
        |> send_resp(500, reason)
    end
  end

  def redirect_to_original_url(conn, params) do
    short_url = String.trim(params["code"])

    with data <- get_one_url(short_url),
         {:ok, _struct} <- update_redirect_count(short_url) do
      if NaiveDateTime.diff(NaiveDateTime.utc_now(), data.inserted_at) < 24 * 60 * 60 do
        conn
        |> redirect(external: data.original_url)
      else
        conn
        |> send_resp(500, "Ссылка недействительна")
      end
    end
  end
end
