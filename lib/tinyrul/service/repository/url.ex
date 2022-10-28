defmodule Tinyrul.Repository.Url do
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias Tinyrul.Repo

  schema "url" do
    field(:original_url, :string)
    field(:short_url, :string)
    field(:redirect_count, :integer)
    field(:delete_time, :utc_datetime)
  end

  def changeset(%__MODULE__{} = schema, params \\ %{}) do
    schema
    |> cast(params, [:original_url, :short_url, :redirect_count, :delete_time])
    |> validate_required([:original_url, :short_url, :redirect_count])
    |> unique_constraint(:short_url)
  end

  def insert(original_url, short_url, redirect_count \\ 0) do
    changeset(%Tinyrul.Repository.Url{}, %{
      original_url: original_url,
      short_url: short_url,
      redirect_count: redirect_count
    })
    |> Repo.insert()
  end

  def get_one_url(short_url) do
    from(u in Tinyrul.Repository.Url,
      where: u.short_url == ^short_url,
      select: u
    )
    |> Repo.one()
  end

  def update_redirect_count(short_url) do
    url = get_one_url(short_url)

    Repo.update(Tinyrul.Repository.Url.changeset(url, %{redirect_count: url.redirect_count + 1}))
  end

  def delete_link(short_url)do
    get_one_url(short_url)
    |> Repo.delete()
  end

  def delete_links()do
    Repo.delete_all(from u in Tinyrul.Repository.Url,
    where: u.delete_time < ^(NaiveDateTime.local_now())
  )
  end
end
