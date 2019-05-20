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

defmodule DemoSeeds do
  def insert_genres do
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
  end

  def insert_artists do
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
  end

  def insert_locations do
    Gigpillar.Repo.insert!(%Gigpillar.Locations.Location{
      name: "Dachstock",
      address: "Neubrückstrasse 8, Bern, Switzerland",
      google_place_id: "ChIJ-SskKr45jkcRPqmGB-ZGsRE",
      lat: 46.9527882,
      lng: 7.4384452
    })

    Gigpillar.Repo.insert!(%Gigpillar.Locations.Location{
      name: "Rössli",
      address: "Neubrückstrasse 8, Bern, Switzerland",
      lat: 46.9527882,
      lng: 7.4384452
    })

    Gigpillar.Repo.insert!(%Gigpillar.Locations.Location{
      name: "Jugendkulturhaus Dynamo",
      address: "Wasserwerkstrasse 21, 8006 Zürich, Switzerland",
      google_place_id: "ChIJP_cBiAsKkEcRQBFT6SDSjk4",
      lat: 47.383401,
      lng: 8.5393821
    })

    Gigpillar.Repo.insert!(%Gigpillar.Locations.Location{
      name: "Cassiopeia",
      address: "Revaler Str. 99, 10245 Berlin, Germany",
      lat: 52.5072755,
      lng: 13.4526039
    })
  end

  def insert_gig(gig, gig_artists) do
    gig = Gigpillar.Repo.insert!(gig)

    Gigpillar.Repo.insert_all(
      Gigpillar.Gigs.GigArtist,
      gig_artists
      |> Enum.map(fn gig_artist -> Map.put(gig_artist, :gig_id, gig.id) end)
    )
  end

  def insert_gigs do
    %Gigpillar.Gigs.Gig{
      name: "Darkside - Pendulum, Camo & Crooked",
      location_id: Gigpillar.Locations.get_location_by_name!("Dachstock").id,
      date: DateTime.from_naive!(~N[2019-12-17 22:00:00], "Etc/UTC"),
      tickets: "https://www.petzitickets.ch/"
    }
    |> insert_gig([
      %{
        artist_id: Gigpillar.Artists.get_artist_by_name!("Pendulum").id,
        plays_at: ~T[03:00:00]
      },
      %{
        artist_id: Gigpillar.Artists.get_artist_by_name!("Camo & Krooked").id,
        plays_at: ~T[01:00:00]
      }
    ])

    %Gigpillar.Gigs.Gig{
      name: "Darkside - Noisia, Spor",
      location_id: Gigpillar.Locations.get_location_by_name!("Dachstock").id,
      date: DateTime.from_naive!(~N[2019-05-30 22:00:00], "Etc/UTC"),
      tickets: "https://www.petzitickets.ch/"
    }
    |> insert_gig([
      %{
        artist_id: Gigpillar.Artists.get_artist_by_name!("Noisia").id,
        plays_at: ~T[03:00:00]
      },
      %{
        artist_id: Gigpillar.Artists.get_artist_by_name!("Spor").id,
        plays_at: ~T[01:00:00]
      }
    ])

    %Gigpillar.Gigs.Gig{
      name: "MAX RAPTOR",
      location_id: Gigpillar.Locations.get_location_by_name!("Rössli").id,
      date: DateTime.from_naive!(~N[2019-06-06 20:00:00], "Etc/UTC"),
      tickets: "https://www.petzitickets.ch/"
    }
    |> insert_gig([
      %{
        artist_id: Gigpillar.Artists.get_artist_by_name!("Max Raptor").id,
        plays_at: ~T[22:00:00]
      },
      %{
        artist_id: Gigpillar.Artists.get_artist_by_name!("Russkaja").id,
        plays_at: ~T[20:00:00]
      }
    ])

    %Gigpillar.Gigs.Gig{
      name: "Mobina Galore",
      location_id: Gigpillar.Locations.get_location_by_name!("Jugendkulturhaus Dynamo").id,
      date: DateTime.from_naive!(~N[2019-05-30 18:30:00], "Etc/UTC"),
      tickets: "https://www.ticketino.com/de/Event/Mobina-Galore/82201"
    }
    |> insert_gig([
      %{
        artist_id: Gigpillar.Artists.get_artist_by_name!("Mobina Galore").id,
        plays_at: ~T[20:00:00]
      }
    ])

    %Gigpillar.Gigs.Gig{
      name: "MAX RAPTOR",
      location_id: Gigpillar.Locations.get_location_by_name!("Cassiopeia").id,
      date: DateTime.from_naive!(~N[2019-05-30 20:00:00], "Etc/UTC"),
      tickets: "https://www.petzitickets.ch/"
    }
    |> insert_gig([
      %{
        artist_id: Gigpillar.Artists.get_artist_by_name!("Max Raptor").id,
        plays_at: ~T[22:00:00]
      },
      %{
        artist_id: Gigpillar.Artists.get_artist_by_name!("Mobina Galore").id,
        plays_at: ~T[20:00:00]
      }
    ])
  end

  def run do
    insert_genres()
    insert_artists()
    insert_locations()
    insert_gigs()
  end
end

DemoSeeds.run()
