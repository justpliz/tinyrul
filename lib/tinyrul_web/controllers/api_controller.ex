defmodule TinyrulWeb.ApiController do
  use TinyrulWeb, :controller

  import Tinyrul.UrlService

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def create_url(conn, params) do
    answer = generate_short_url(params["original_url"])

    case answer do
      {:ok, random_key, status} ->
        conn
        |> put_resp_header("content-type", "application/json")
        |> send_resp(status, Jason.encode!(%{short_url_key: random_key}))

      {:error, reason} ->
        IO.inspect(reason, label: "unexpected error reason")

        conn
        |> put_resp_header("content-type", "application/json")
        |> send_resp(500, Jason.encode!(%{error: "unexpected error"}))
    end
  end

  def redirect_by_original_url(conn, params) do
    answer = treatment_code(params["code"])

    case answer do
      {:ok, original_url} ->
        conn
        |> redirect(external: original_url)

      {:error, status} ->
        conn
        |> put_resp_header("content-type", "application/json")
        |> send_resp(status, Jason.encode!(%{error: "link is invalid"}))

      {:error} ->
        conn
        |> put_resp_header("content-type", "application/json")
        |> send_resp(404, Jason.encode!(%{error: "not found"}))
    end
  end
end
