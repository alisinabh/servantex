defmodule ServantexWeb.Plugs.ThingAuthPlug do
  @moduledoc """
  Authorization plug for identifing things (controllers)
  """

  import Plug.Conn

  require Logger

  alias Servantex.DeviceManager

  @auth_conn_priv_key :thing_auth_data

  def init(opts), do: opts

  def call(conn, _opts) do
    with [auth_data | _] <- get_req_header(conn, "authorization"),
         [user_id, controller_secret] <- String.split(auth_data, ":"),
         {:valid, ^user_id, controller_id} <-
           DeviceManager.check_controller_auth(user_id, controller_secret) do
      conn
      |> put_private(@auth_conn_priv_key, %{
        user_id: user_id,
        controller_id: controller_id,
        fw_version: 1
      })
    else
      auth_error ->
        Logger.info("Auth error: #{inspect(auth_error)}")

        conn
        |> resp(401, "UNAUTHORIZED")
        |> halt
    end
  end

  @doc """
  Returns controller information.

  `{:ok, user_id, controller_id, firmware_version}`
  """
  def get_controller_info(conn) do
    %{user_id: user_id, controller_id: controller_id, fw_version: fw_version} =
      conn.private[@auth_conn_priv_key]

    {:ok, user_id, controller_id, fw_version}
  end
end
