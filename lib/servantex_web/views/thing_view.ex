defmodule ServantexWeb.ThingView do
  use ServantexWeb, :view

  def render("pin_modes.json", %{fw_version: fw_version, controller: controller}) do
    db_pin_modes = controller.extras["pin_modes"]

    pin_modes =
      for pin <- db_pin_modes do
        render_pinmode(pin, fw_version)
      end

    %{"pins" => pin_modes}
  end

  def render("pin_status.json", %{fw_version: _fw_version, controller: controller}) do
    db_states = Map.to_list(controller.extras["status"])

    states =
      for {pin_number, pin_data} <- db_states do
        render_pin_status(pin_number, pin_data)
      end

    %{"states" => states}
  end

  defp render_pin_status(pin_number, data) do
    {value, transition} =
      case data do
        %{"value" => value} ->
          {value, data["transition"] || 0}
      end

    %{"p" => pin_number, "s" => value, "t" => transition}
  end

  defp render_pinmode(pin, 1) do
    {mode, default, ref_pin} =
      case pin do
        %{"mode" => "output"} ->
          {1, pin["default"] || 0, -1}

        %{"mode" => "input"} ->
          {2, 0, pin["ref_pin"] || -1}

        %{"mode" => "input_pullup"} ->
          {3, 0, pin["ref_pin"] || -1}
      end

    %{"p" => pin["pin"], "m" => mode, "v" => default, "r" => ref_pin}
  end
end
