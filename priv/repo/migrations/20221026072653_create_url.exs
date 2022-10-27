defmodule Tinyrul.Repo.Migrations.CreateUrl do
  use Ecto.Migration

  def change do
    create table("url") do
      add :original_url, :text
      add :short_url, :string
      add :redirect_count, :integer

      timestamps()
    end
  end
end
