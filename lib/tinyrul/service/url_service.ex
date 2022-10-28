defmodule Tinyrul.UrlService do
  import Tinyrul.Repository.Url

  def generate_short_url(original_url) do
    random_key =
      original_url
      |> String.trim()
      |> (&:crypto.hash(:md5, &1)).()
      |> Base.encode16(case: :lower)
      |> String.slice(0, 10)

    case insert(original_url, random_key) do
      {:ok, _inserted} ->
        {:ok, random_key, 201}

      {:error, %Ecto.Changeset{errors: [short_url: {"has already been taken", _}]}} ->
        {:ok, random_key, 200}

      {:error, reason} ->
        {:error, reason}
    end
  end

  def treatment_code(code) do
    short_url = String.trim(code)

    with data <- get_one_url(short_url),
         false <- is_nil(data),
         {:ok, _struct} <- update_redirect_count(short_url) do
      if NaiveDateTime.diff(NaiveDateTime.local_now(), data.delete_time) < 0 do
        {:ok, data.original_url}
      else
        delete_link(short_url)
        {:error, 501}
      end
    else
      _any ->
        {:error}
    end
  end
end

# if not is_nil(Url.get_one_url(short_url)),
#   do: generate_short_url(host, port),
#   else: random_key обработать ошибку с базы
