defmodule TinyrulWeb.ApiController do
  use TinyrulWeb, :controller

  import Tinyrul.{UrlService, Repository.Url}

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def url(conn, params) do
    original_url = params["original_url"]
    random_key = generate_short_url(original_url)

    case insert(original_url, random_key) do
      {:ok, _inserted} ->
        conn
        |> send_resp(201, Jason.encode!(%{short_url_key: random_key}))

      {:error, %Ecto.Changeset{errors: [short_url: {"has already been taken", _}]}} ->
        conn
        |> send_resp(201, Jason.encode!(%{short_url_key: random_key}))

      {:error, reason} ->
        IO.inspect(reason, label: "reason")
        conn
        |> send_resp(500, Jason.encode!(%{error: "unexpected error"}))
    end
    # random_key = generate_short_url(conn.host, conn.port)

    # case insert(original_url, random_key) do
  end

  def redirect_to_original_url(conn, params) do
    short_url = String.trim(params["code"])

    with data <- get_one_url(short_url),
         false <- is_nil(data),
         {:ok, _struct} <- update_redirect_count(short_url) do
      if NaiveDateTime.diff(NaiveDateTime.local_now(), data.delete_time) > 0 do
        conn
        |> redirect(external: data.original_url)
      else
        delete_link(short_url)
        conn
        |> send_resp(500, Jason.encode!(%{error: "link is invalid"}))
      end
    else
      _any ->
        conn
        |> send_resp(404, Jason.encode!(%{error: "not found"}))
    end
  end
end
