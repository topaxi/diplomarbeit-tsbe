defmodule Gigpillar.Storage.Uploader.Picture do
  use Arc.Definition
  use Arc.Ecto.Definition

  @versions [:original, :thumbnail]

  def validate({file, _}) do
    ~w(.jpg .jpeg .png) |> Enum.member?(Path.extname(file.file_name))
  end

  def transform(:thumbnail, _) do
    {:convert, "-strip -thumbnail 160x160^ -gravity center -extent 160x160"}
  end

  def asset_host do
    Application.get_env(:gigpillar, :asset_host)
  end
end
