defmodule Gigpillar.Storage.Uploader.Picture do
  use Arc.Definition
  use Arc.Ecto.Definition

  @versions [:original, :list, :thumbnail]

  def validate({file, _}) do
    ~w(.jpg .jpeg .png) |> Enum.member?(Path.extname(file.file_name))
  end

  def transform(:list, _) do
    {:convert, "-strip -thumbnail 288x224^ -gravity center -extent 288x224"}
  end

  def transform(:thumbnail, _) do
    {:convert, "-strip -thumbnail 160x56^ -gravity center -extent 160x56"}
  end

  def filename(version, {file, scope}) do
    "gigs/#{scope.id}/#{version}"
  end

  def filename(version, _), do: version

  def asset_host do
    Application.get_env(:gigpillar, :asset_host)
  end
end
