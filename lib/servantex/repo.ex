defmodule Servantex.Repo do
  use Ecto.Repo,
    otp_app: :servantex,
    adapter: Ecto.Adapters.Postgres
end
