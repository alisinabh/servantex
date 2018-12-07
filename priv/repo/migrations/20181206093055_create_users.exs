defmodule Servantex.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :email, :string
      add :password_hash, :string, null: false
      add :is_enabled, :boolean, default: false, null: false
      add :max_devices, :integer

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
