defmodule TinyrulWeb.Router do
  use TinyrulWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TinyrulWeb do
    pipe_through :api

    get "/", ApiController, :index
    post "/url", ApiController, :create_url

    get "/:code", ApiController, :redirect_by_original_url
  end
end
