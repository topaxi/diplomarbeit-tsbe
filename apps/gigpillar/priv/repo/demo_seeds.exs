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
  def insert_user do
    Gigpillar.Accounts.register_user(%{
      "username" => "topaxi",
      "email" => "damian.senn@gmail.com",
      "password" => "1234qwer",
      "password_confirmation" => "1234qwer"
    })
  end

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

  defp get_genre_by_name!(name) do
    Gigpillar.Repo.get_by!(Gigpillar.Genres.Genre, name: name)
  end

  def insert_gig(gig, gig_artists, genres) do
    gig = Gigpillar.Repo.insert!(Map.put(gig, :creator_id, 1))

    Gigpillar.Repo.insert_all(
      Gigpillar.Gigs.GigArtist,
      gig_artists
      |> Enum.map(fn gig_artist -> Map.put(gig_artist, :gig_id, gig.id) end)
    )

    Gigpillar.Repo.insert_all(
      Gigpillar.Gigs.GigGenre,
      genres
      |> Enum.map(&get_genre_by_name!/1)
      |> Enum.map(fn genre -> %{gig_id: gig.id, genre_id: genre.id} end)
    )
  end

  def insert_gigs do
    %Gigpillar.Gigs.Gig{
      name: "Darkside - Pendulum, Camo & Crooked",
      location_id: Gigpillar.Locations.get_location_by_name!("Dachstock").id,
      description: lorem(),
      date: DateTime.from_naive!(~N[2019-12-17 22:00:00], "Etc/UTC"),
      tickets: "https://www.petzitickets.ch/"
    }
    |> insert_gig(
      [
        %{
          artist_id: Gigpillar.Artists.get_artist_by_name!("Pendulum").id,
          plays_at: ~T[03:00:00]
        },
        %{
          artist_id: Gigpillar.Artists.get_artist_by_name!("Camo & Krooked").id,
          plays_at: ~T[01:00:00]
        }
      ],
      ["EDM"]
    )

    %Gigpillar.Gigs.Gig{
      name: "Darkside - Noisia, Spor",
      location_id: Gigpillar.Locations.get_location_by_name!("Dachstock").id,
      description: lorem(),
      date: DateTime.from_naive!(~N[2019-05-30 22:00:00], "Etc/UTC"),
      tickets: "https://www.petzitickets.ch/"
    }
    |> insert_gig(
      [
        %{
          artist_id: Gigpillar.Artists.get_artist_by_name!("Noisia").id,
          plays_at: ~T[03:00:00]
        },
        %{
          artist_id: Gigpillar.Artists.get_artist_by_name!("Spor").id,
          plays_at: ~T[01:00:00]
        }
      ],
      ["EDM"]
    )

    %Gigpillar.Gigs.Gig{
      name: "MAX RAPTOR",
      location_id: Gigpillar.Locations.get_location_by_name!("Rössli").id,
      description: lorem(),
      date: DateTime.from_naive!(~N[2019-06-06 20:00:00], "Etc/UTC"),
      tickets: "https://www.petzitickets.ch/"
    }
    |> insert_gig(
      [
        %{
          artist_id: Gigpillar.Artists.get_artist_by_name!("Max Raptor").id,
          plays_at: ~T[22:00:00]
        },
        %{
          artist_id: Gigpillar.Artists.get_artist_by_name!("Russkaja").id,
          plays_at: ~T[20:00:00]
        }
      ],
      ["Rock", "Punk"]
    )

    %Gigpillar.Gigs.Gig{
      name: "Mobina Galore",
      location_id: Gigpillar.Locations.get_location_by_name!("Jugendkulturhaus Dynamo").id,
      description:
        "Mobina Galore leben und arbeiten in einem Umfeld, einer Szene, einem Genre, das immer noch von Männern dominiert wird. Seit ihrer Gründung im Jahr 2010 mussten sie sich immer wieder mit den widerlichsten Äußerungen, doofen Kommentaren wie „ihr seid ja eigentlich ziemlich gut“ und herablassenden Clubbesitzern rumschlagen. Dazu kommt die heimtückische Herausforderung der Überwindung der gläsernen Decke der Musikindustrie. Immer wieder werden sie mit Sexismus konfrontiert, doch genau das motiviert Gitarristin/ Sängerin Jenna Priestner und Schlagzeugerin Marcia Hanson nur dazu, noch härter zu arbeiten und an dem festzuhalten, was sie am besten können: großartige Punk Rock Songs zu schreiben, die für sich selbst sprechen.",
      date: DateTime.from_naive!(~N[2019-05-30 18:30:00], "Etc/UTC"),
      tickets: "https://www.ticketino.com/de/Event/Mobina-Galore/82201"
    }
    |> insert_gig(
      [
        %{
          artist_id: Gigpillar.Artists.get_artist_by_name!("Mobina Galore").id,
          plays_at: ~T[20:00:00]
        }
      ],
      ["Rock", "Punk"]
    )

    %Gigpillar.Gigs.Gig{
      name: "MAX RAPTOR",
      location_id: Gigpillar.Locations.get_location_by_name!("Cassiopeia").id,
      description: lorem(),
      date: DateTime.from_naive!(~N[2019-05-30 20:00:00], "Etc/UTC"),
      tickets: "https://www.petzitickets.ch/"
    }
    |> insert_gig(
      [
        %{
          artist_id: Gigpillar.Artists.get_artist_by_name!("Max Raptor").id,
          plays_at: ~T[22:00:00]
        },
        %{
          artist_id: Gigpillar.Artists.get_artist_by_name!("Mobina Galore").id,
          plays_at: ~T[20:00:00]
        }
      ],
      ["Rock", "Punk"]
    )

    %Gigpillar.Gigs.Gig{
      name: "Parkway Drive",
      location_id: Gigpillar.Locations.get_location_by_name!("Cassiopeia").id,
      description: lorem(),
      date: DateTime.from_naive!(~N[2019-05-30 20:00:00], "Etc/UTC"),
      tickets: "https://www.petzitickets.ch/"
    }
    |> insert_gig(
      [
        %{
          artist_id: Gigpillar.Artists.get_artist_by_name!("Parkway Drive").id,
          plays_at: ~T[22:00:00]
        },
        %{
          artist_id: Gigpillar.Artists.get_artist_by_name!("Breakdown of Sanity").id,
          plays_at: ~T[20:00:00]
        }
      ],
      ["Rock", "Metal"]
    )
  end

  def lorem do
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec non ante lacinia arcu elementum dapibus. Etiam convallis tincidunt rutrum. Praesent id ipsum dolor. Aliquam finibus purus ut erat varius dignissim. Vestibulum molestie neque congue turpis interdum, vitae auctor orci tempus. Aenean ultrices ex sed leo interdum porta. Maecenas in magna eu turpis condimentum ultricies non ut diam. Aliquam id sagittis felis. Curabitur urna nisl, lacinia ut nulla pulvinar, varius blandit ipsum. Phasellus et mollis dui. In pretium porttitor metus, scelerisque aliquam ante dapibus sed. Nunc ullamcorper eget est id tempus. Vivamus convallis et quam ut ornare. Aliquam erat volutpat."
  end

  def run do
    insert_user()
    insert_genres()
    insert_artists()
    insert_locations()
    insert_gigs()
  end
end

DemoSeeds.run()
