alias Gigpillar.Accounts.User
alias Gigpillar.Gigs.Gig

defimpl Canada.Can, for: User do
  # User can list their gigs and create new gigs
  def can?(%User{}, action, Gig)
      when action in [:index, :new, :create],
      do: true

  # User can edit and delete their own gigs
  def can?(%User{id: uid}, action, %Gig{creator_id: uid})
      when action in [:edit, :update, :delete],
      do: true

  # User can show any gig
  def can?(%User{}, :show, %Gig{}), do: true

  # User is not allowed to do anything else
  def can?(%User{}, _, _), do: false
end

defimpl Canada.Can, for: Atom do
  # Anyone can show a specific gig
  def can?(nil, :show, %Gig{}), do: true

  # By default, nothing is permitted
  def can?(nil, _, _), do: false
end
