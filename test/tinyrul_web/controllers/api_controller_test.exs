defmodule TinyrulWeb.ApiControllerTest do
  use TinyrulWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert Tinyrul.UrlService.generate_short_url("https://stackoverflow.com/questions/36134979/hash-md5-in-elixir") =~ "Welcome to Phoenix!"
  end
end
