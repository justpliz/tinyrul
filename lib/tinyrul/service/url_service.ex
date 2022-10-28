defmodule Tinyrul.UrlService do
  alias Tinyrul.Repository.Url, as: Url

  def generate_short_url(original_url) do
      :crypto.hash(:md5 , original_url) |> Base.encode16(case: :lower) |> String.slice(0, 10)

    # short_url = "http://#{host}:#{port}/#{random_key}"

    # if not is_nil(Url.get_one_url(short_url)),
    #   do: generate_short_url(host, port),
    #   else: random_key обработать ошибку с базы
  end
end
