defmodule ServantexWeb.ThingController do
  use ServantexWeb, :controller

  require Logger

  alias ServantexWeb.Plugs.ThingAuthPlug
  alias Servantex.DeviceManager

  def pin_modes(conn, _params) do
    {:ok, _user_id, controller_id, fw_version} = ThingAuthPlug.get_controller_info(conn)

    controller = DeviceManager.get_controller!(controller_id)

    render(conn, "pin_modes.json", fw_version: fw_version, controller: controller)
  end

  def pull(conn, _params) do
    {:ok, _user_id, controller_id, fw_version} = ThingAuthPlug.get_controller_info(conn)

    controller = DeviceManager.get_controller!(controller_id)

    render(conn, "pin_status.json", fw_version: fw_version, controller: controller)
  end

  def push(conn, params) do
    {:ok, _user_id, controller_id, _fw_version} = ThingAuthPlug.get_controller_info(conn)

    controller = DeviceManager.get_controller!(controller_id)

    status = controller.extras["status"] || %{}

    {:ok, status} = process_updates(status, Map.to_list(params))
    extras = Map.put(controller.extras, "status", status)

    {:ok, _controller} = DeviceManager.update_controller(controller, %{extras: extras})

    conn
    |> put_status(:ok)
    |> text("OK")
  end

  defp process_updates(status, [{<<"pin", pin::binary>>, str_value} | t]) do
    {value, _} = Integer.parse(str_value)
    min_change_avail_time = status[pin]["lock_until"] || 0

    status =
      if min_change_avail_time < System.system_time(:seconds) do
        Map.put(status, pin, %{"value" => value})
      else
        status
      end

    process_updates(status, t)
  end

  defp process_updates(status, []) do
    {:ok, status}
  end
end
