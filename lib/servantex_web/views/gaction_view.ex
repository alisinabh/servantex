defmodule ServantexWeb.GactionView do
  use ServantexWeb, :view

  alias Servantex.DeviceManager

  def render("sync.json", %{conn: conn, devices: devices, user_id: user_id}) do
    google_devices =
      for dev <- devices do
        render_device_sync(dev)
      end

    %{
      "requestId" => conn.private[:request_id],
      "payload" => %{
        "agentUserId" => user_id,
        "devices" => google_devices
      }
    }
  end

  def render("query.json", %{conn: conn, devices: devices}) do
    %{"requestId" => conn.private[:request_id], "payload" => %{"devices" => devices}}
  end

  def render("execute.json", %{conn: conn, command_devices_grouped: devices_grouped}) do
    ids =
      for devs <- devices_grouped do
        %{"ids" => devs, "status" => "SUCCESS"}
      end

    %{"requestId" => conn.private[:request_id], "payload" => %{"commands" => ids}}
  end

  defp render_device_sync(device) do
    traits = DeviceManager.list_device_traits(device.id)

    %{
      "id" => device.id,
      "name" => device.name,
      "type" => device.type,
      "traits" => traits,
      "roomHint" => device.extras["room"] || nil,
      "willReportState" => false
    }
  end
end
