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
    config = Application.get_env(:ex_aws, :s3)
    bucket = Application.get_env(:arc, :bucket)
    "#{config[:scheme]}#{config[:host]}:#{config[:port]}/#{bucket}"
  end
end
