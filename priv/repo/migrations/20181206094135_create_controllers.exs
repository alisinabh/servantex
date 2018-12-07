defmodule Servantex.Repo.Migrations.CreateControllers do
  use Ecto.Migration

  def change do
    create table(:controllers, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :type, :string
      add :name, :string
      add :secret, :string
      add :extras, :map
      add :is_enabled, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:controllers, [:user_id])
    create unique_index(:controllers, [:user_id, :secret])
  end
end
