defmodule Tinyrul.Repo.Migrations.CreateUrl do
  use Ecto.Migration

  def change do
    create table("url") do
      add :original_url, :text
      add :short_url, :string
      add :redirect_count, :integer
      add :delete_time, :utc_datetime, default: fragment("NOW() + interval '24 hours'")
    end
    create index("url", [:short_url], unique: true)
  end
end
