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

Gigpillar.Repo.insert_all(
  Gigpillar.Artists.Artist,
  [
    "Parkway Drive",
    "In Flames",
    "Pennywise",
    "Goldfinger",
    "Talco",
    "NOFX",
    "Authority Zero",
    "Disturbed",
    "Breakdown of Sanity",
    "No Use for a Name",
    "Honningbarna",
    "Bad Religion",
    "Anti-Flag",
    "The Suicide Machines",
    "Morcheeba",
    "No Fun at All",
    "Billy Talent",
    "Rage Against the Machine",
    "Mad Caddies",
    "Noisia",
    "Sum 41",
    "Rise Against",
    "Spor",
    "Max Raptor",
    "Broilers",
    "Audio",
    "Reel Big Fish",
    "501",
    "Linkin Park",
    "Jamaram",
    "Social Distortion",
    "Backyard Babies",
    "Streetlight Manifesto",
    "Breaking Benjamin",
    "Zebrahead",
    "Within Temptation",
    "Netsky",
    "Gentleman",
    "Hoobastank",
    "Russkaja",
    "Flux Pavilion",
    "Sonic Boom Six",
    "Itchy Poopzkid",
    "Ska-P",
    "B-Complex",
    "The Baboon Show",
    "Less Than Jake",
    "Nero",
    "Camo & Krooked",
    "Pendulum",
    "Mobina Galore"
  ]
  |> Enum.map(fn artist ->
    %{
      name: artist,
      inserted_at: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second),
      updated_at: NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    }
  end)
)
