defmodule Tinyrul.UrlService do
  alias Tinyrul.Repository.Url, as: Url

  def generate_short_url(host, port) do
    random_key =
      for _ <- 1..10, into: "", do: <<Enum.random('0123456789abcdefghijklmnopqrstuvwxyz')>>

    short_url = "http://#{host}:#{port}/#{random_key}"

    if not is_nil(Url.get_one_url(short_url)),
      do: generate_short_url(host, port),
      else: random_key
  end
end
