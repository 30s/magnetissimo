defmodule Magnetissimo.Torrent do
  use Magnetissimo.Web, :model

  schema "torrents" do
    field :name, :string
    field :magnet, :string
    field :leechers, :integer
    field :seeders, :integer
    field :source, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :magnet, :leechers, :seeders, :source])
    |> validate_required([:name, :magnet, :leechers, :seeders, :source])
    |> validate_length(:leechers, min: 0)
    |> validate_length(:seeders, min: 0)
    |> unique_constraint(:magnet)
  end
end
