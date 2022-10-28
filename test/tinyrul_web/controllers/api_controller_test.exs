defmodule TinyrulWeb.ApiControllerTest do
  use ExUnit.Case, async: true

  test "Correct generate_short_url" do
    assert(Tinyrul.UrlService.generate_short_url("https://stackoverflow.com/questions/36134979/hash-md5-in-elixir") == {:ok, "6e3b50b2ab", 200})

    assert(Tinyrul.UrlService.generate_short_url("https://vk.com/id43913672") == {:ok, "08b5750338", 200})

    assert(Tinyrul.UrlService.generate_short_url("https://www.youtube.com/watch?v=h8gGbq06mHw&t=1795s") == {:ok, "1fc1a9ac05", 200})
  end

  test "Correct treatment_code" do
    assert(Tinyrul.UrlService.treatment_code("6e3b50b2ab") == {:ok, "https://stackoverflow.com/questions/36134979/hash-md5-in-elixir"})

    assert(Tinyrul.UrlService.treatment_code("08b5750338") == {:ok, "https://vk.com/id43913672"})

    assert(Tinyrul.UrlService.treatment_code("1fc1a9ac05") == {:ok, "https://www.youtube.com/watch?v=h8gGbq06mHw&t=1795s"})
  end
end
