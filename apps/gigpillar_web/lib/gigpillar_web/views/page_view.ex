defmodule GigpillarWeb.PageView do
  use GigpillarWeb, :view

  def picture(gig) do
    Gigpillar.Gigs.Gig.picture({gig.picture, gig}, :list)
  end
end
