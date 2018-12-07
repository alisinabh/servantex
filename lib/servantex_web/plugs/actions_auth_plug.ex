defmodule ServantexWeb.Plugs.ActionsAuthPlug do
  @moduledoc """
  Authorization plug for service accounts.
  """

  import Plug.Conn

  require Logger

  alias Servantex.Accounts

  @auth_conn_priv_key :service_auth_data

  def init(opts), do: opts

  def call(conn, opts) do
    with [auth_data | _] <- get_req_header(conn, "authorization"),
         {:ok, user_id, token_id} <- Accounts.verify_token() do
      conn
      |> put_private(@auth_conn_priv_key, %{user_id: user_id, token_id: token_id})
    else
      auth_error ->
        Logger.error("Auth error: #{inspect(auth_error)}")

        conn
        |> resp(401, "UNAUTHORIZED")
        |> halt
    end
  end

  def get_user_info(conn) do
    %{user_id: user_id, token_id: token_id} = conn.private[@auth_conn_priv_key]

    {:ok, user_id, token_id}
  end
end
