# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Gigpillar.Repo.insert!(%Gigpillar.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

[
  "Alternative",
  "Blues",
  "Classical",
  "EDM",
  "Hip-Hop",
  "Jazz",
  "Metal",
  "Pop",
  "Punk",
  "Reggae",
  "Rock"
]
|> Enum.map(fn genre -> %Gigpillar.Genres.Genre{name: genre} end)
|> Enum.each(fn genre -> Gigpillar.Repo.insert!(genre) end)
