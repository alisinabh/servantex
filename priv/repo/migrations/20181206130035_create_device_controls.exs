defmodule Servantex.Repo.Migrations.CreateDeviceControls do
  use Ecto.Migration

  def change do
    create table(:device_controls, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :trait, :string
      add :action, :map
      add :device_id, references(:devices, on_delete: :nothing, type: :binary_id)
      add :controller_id, references(:controllers, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:device_controls, [:device_id])
    create index(:device_controls, [:controller_id])
  end
end
