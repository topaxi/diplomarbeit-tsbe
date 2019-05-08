alias Gigpillar.Accounts.User
alias Gigpillar.Gigs.Gig

defimpl Canada.Can, for: User do
  def can?(%User{}, :index, Gig), do: true
  def can?(%User{}, :new, Gig), do: true

  def can?(%User{id: user_id}, :edit, %Gig{creator_id: user_id}), do: true

  def can?(%User{}, :show, %Gig{}), do: true
  def can?(%User{}, _, _), do: false
end

defimpl Canada.Can, for: Atom do
  def can?(nil, :show, %Gig{}), do: true
  def can?(nil, _, _), do: false
end
