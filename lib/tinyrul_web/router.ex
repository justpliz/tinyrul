defmodule TinyrulWeb.Router do
  use TinyrulWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TinyrulWeb do
    pipe_through :api

    get "/", ApiController, :index
    post "/url", ApiController, :url
    get "/short_url", ApiController, :short_url

    get "/:code", ApiController, :redirect_to_original_url
  end

end
