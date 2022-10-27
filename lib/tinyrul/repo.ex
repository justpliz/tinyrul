defmodule Tinyrul.Repo do
  use Ecto.Repo,
    otp_app: :tinyrul,
    adapter: Ecto.Adapters.Postgres
end
