defmodule Servantex.Accounts.Token do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "tokens" do
    field :client_id, :string
    field :token, :string
    field :type, :string
    field :user_id, :binary_id
    # TODO: Add is enabled

    timestamps()
  end

  @doc false
  def changeset(token, attrs) do
    token
    |> cast(attrs, [:type, :client_id, :token, :user_id])
    |> validate_required([:type, :client_id, :token])
    |> unique_constraint(:token)
  end
end
