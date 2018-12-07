defmodule ServantexWeb.GactionController do
  use ServantexWeb, :controller

  alias Servantex.DeviceManager
  alias ServantexWeb.Plugs.ActionsAuthPlug

  def gaction(conn, params) do
    request_id = params["requestId"]
    conn = put_private(conn, :request_id, request_id)

    [input] = params["inputs"]

    case input do
      %{"intent" => "action.devices.SYNC"} ->
        process_sync_request(conn)

      %{"intent" => "action.devices.QUERY", "payload" => payload} ->
        process_query_request(conn, payload)

      %{"intent" => "action.devices.EXECUTE", "payload" => payload} ->
        process_execute_request(conn, payload)

      %{"intent" => "action.devices.DISCONNECT"} ->
        #      revoke_google_auth(conn)
        :ok
    end
  end

  def process_sync_request(conn) do
    {:ok, user_id, _token_id} = ActionsAuthPlug.get_user_info(conn)

    devices = DeviceManager.list_user_devices(user_id)

    render(conn, "sync.json", conn: conn, devices: devices, user_id: user_id)
  end

  def process_query_request(conn, payload) do
    {:ok, user_id, _token_id} = ActionsAuthPlug.get_user_info(conn)

    devices = payload["devices"]

    result =
      Enum.reduce(devices, %{}, fn device, acc ->
        status = DeviceManager.get_device_status(user_id, device["id"])

        Map.put(acc, device["id"], status)
      end)

    render(conn, "query.json", conn: conn, devices: result)
  end

  def process_execute_request(conn, payload) do
    {:ok, user_id, _token_id} = ActionsAuthPlug.get_user_info(conn)

    commands = payload["commands"]

    command_devices_grouped =
      for command <- commands do
        execute_command(user_id, command)
      end

    render(conn, "execute.json", conn: conn, command_devices_grouped: command_devices_grouped)
  end

  defp execute_command(_user_id, %{
         "devices" => devices,
         "execution" => execs
       }) do
    device_ids = get_device_ids(devices)
    # TODO: Ensure device ownership
    for %{"command" => trait, "params" => params} <- execs do
      for device_id <- device_ids do
        DeviceManager.apply_trait_action(device_id, trait, params)
      end
    end

    device_ids
  end

  defp get_device_ids(devices) do
    Enum.reduce(devices, [], fn x, acc -> [x["id"] | acc] end)
  end
end
