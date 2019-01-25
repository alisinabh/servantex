defmodule Servantex.DeviceManager.DeviceControl do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "device_controls" do
    field :action, :map
    field :trait, :string
    field :device_id, :binary_id
    field :controller_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(device_control, attrs) do
    device_control
    |> cast(attrs, [:trait, :action, :device_id, :controller_id])
    |> validate_required([:trait, :action])
  end
end
