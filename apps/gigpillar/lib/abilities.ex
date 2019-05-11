alias Gigpillar.Accounts.User
alias Gigpillar.Gigs.Gig

defimpl Canada.Can, for: User do
  def can?(%User{}, action, Gig) when action in [:index, :new, :create], do: true

  def can?(%User{id: user_id}, action, %Gig{creator_id: user_id})
      when action in [:edit, :update, :delete],
      do: true

  def can?(%User{}, :show, %Gig{}), do: true
  def can?(%User{}, _, _), do: false
end

defimpl Canada.Can, for: Atom do
  def can?(nil, :show, %Gig{}), do: true
  def can?(nil, _, _), do: false
end
