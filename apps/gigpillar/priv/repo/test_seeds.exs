# Script for populating the database. You can run it as:
#
#     mix run priv/repo/test_seeds.exs
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

dachstock =
  Gigpillar.Repo.insert!(%Gigpillar.Locations.Location{
    name: "Dachstock",
    address: "Neubrückstrasse 8, Bern, Switzerland",
    google_place_id: "ChIJ-SskKr45jkcRPqmGB-ZGsRE",
    lat: 46.9527882,
    lng: 7.4384452
  })

dynamo =
  Gigpillar.Repo.insert!(%Gigpillar.Locations.Location{
    name: "Jugendkulturhaus Dynamo",
    address: "Wasserwerkstrasse 21, 8006 Zürich, Switzerland",
    google_place_id: "ChIJP_cBiAsKkEcRQBFT6SDSjk4",
    lat: 47.383401,
    lng: 8.5393821
  })

{:ok, darksideDate} =
  DateTime.from_naive!(~N[2019-12-17 23:00:00], "Europe/Zurich")
  |> DateTime.shift_zone("Etc/UTC")

gig =
  Gigpillar.Repo.insert!(%Gigpillar.Gigs.Gig{
    name: "Darkside - Pendulum, Camo & Crooked",
    location_id: dachstock.id,
    date: darksideDate,
    tickets: "https://www.petzitickets.ch/"
  })

Gigpillar.Repo.insert_all(Gigpillar.Gigs.GigArtist, [
  %{
    gig_id: gig.id,
    artist_id: Gigpillar.Artists.get_artist_by_name!("Pendulum").id,
    plays_at: ~T[03:00:00]
  },
  %{
    gig_id: gig.id,
    artist_id: Gigpillar.Artists.get_artist_by_name!("Camo & Krooked").id,
    plays_at: ~T[01:00:00]
  }
])

{:ok, mobinaGaloreDate} =
  DateTime.from_naive!(~N[2019-05-30 19:30:00], "Europe/Zurich")
  |> DateTime.shift_zone("Etc/UTC")

gig =
  Gigpillar.Repo.insert!(%Gigpillar.Gigs.Gig{
    name: "Mobina Galore",
    location_id: dynamo.id,
    date: mobinaGaloreDate,
    tickets: "https://www.ticketino.com/de/Event/Mobina-Galore/82201"
  })

Gigpillar.Repo.insert_all(Gigpillar.Gigs.GigArtist, [
  %{
    gig_id: gig.id,
    artist_id: Gigpillar.Artists.get_artist_by_name!("Mobina Galore").id,
    plays_at: ~T[20:00:00]
  }
])
