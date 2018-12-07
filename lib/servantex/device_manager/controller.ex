defmodule Servantex.DeviceManager.Controller do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "controllers" do
    field :extras, :map
    field :is_enabled, :boolean, default: false
    field :name, :string
    field :secret, :string
    field :type, :string
    field :user_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(controller, attrs) do
    controller
    |> cast(attrs, [:type, :name, :secret, :user_id, :extras, :is_enabled])
    |> validate_required([:type, :name, :secret, :user_id, :extras, :is_enabled])
    |> unique_constraint(:secret, name: :user_id_secret_index)
  end
end
