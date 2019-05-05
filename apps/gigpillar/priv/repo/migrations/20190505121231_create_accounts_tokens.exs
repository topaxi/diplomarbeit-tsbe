defmodule Gigpillar.Repo.Migrations.CreateAccountsTokens do
  use Ecto.Migration

  def change do
    create table(:accounts_tokens) do
      add(:user_id, references(:users, on_delete: :delete_all), null: false)
      add(:token_id, references(:tokens, on_delete: :delete_all), null: false)
    end

    create(unique_index(:accounts_tokens, [:user_id, :token_id]))
  end
end
