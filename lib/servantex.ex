defmodule Servantex do
  @moduledoc """
  Servantex keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def test_it do
    [c] = Servantex.DeviceManager.list_controllers()

    val = if c.extras["status"]["16"]["value"] >= 255, do: 0, else: 255

    status = Map.put(c.extras["status"], "16", %{"value" => val, "transition" => 5})
    extras = Map.put(c.extras, "status", status)

    Servantex.DeviceManager.update_controller(c, %{extras: extras})
  end

  def test_loop do
    test_it()
    :timer.sleep(2000)
    test_loop()
  end
end
