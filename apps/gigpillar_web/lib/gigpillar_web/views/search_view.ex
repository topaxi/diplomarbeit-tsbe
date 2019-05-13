defmodule GigpillarWeb.SearchView do
  use GigpillarWeb, :view

  def picture(gig) do
    Gigpillar.Gigs.Gig.picture({gig.picture, gig}, :thumbnail)
  end
end
