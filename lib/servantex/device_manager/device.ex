defmodule Servantex.DeviceManager.Device do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "devices" do
    field :extras, :map
    field :is_enabled, :boolean, default: false
    field :name, :string
    field :type, :string
    field :user_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(device, attrs) do
    device
    |> cast(attrs, [:name, :type, :extras, :is_enabled, :user_id])
    |> validate_required([:name, :type, :is_enabled])
  end
end
