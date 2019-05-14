defmodule GigpillarWeb.FeatureCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Wallaby.DSL

      alias Gigpillar.Repo
      import Ecto
      import Ecto.Changeset
      import Ecto.Query

      import GigpillarWeb.Router.Helpers
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Gigpillar.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Gigpillar.Repo, {:shared, self()})
    end

    metadata = Phoenix.Ecto.SQL.Sandbox.metadata_for(Gigpillar.Repo, self())
    {:ok, session} = Wallaby.start_session(metadata: metadata)
    {:ok, session: session}
  end
end
