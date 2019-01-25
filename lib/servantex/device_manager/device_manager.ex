defmodule Servantex.DeviceManager do
  @moduledoc """
  The DeviceManager context.
  """

  import Ecto.Query, warn: false
  alias Servantex.Repo

  alias Servantex.DeviceManager.Controller

  @command_trait Application.get_env(:servantex, :command_trait)
  # Lock timeout of pins in seconds. In this duration no change will be applied to the pin.
  @pin_lock_timeout 3

  @doc """
  Returns the list of controllers.

  ## Examples

      iex> list_controllers()
      [%Controller{}, ...]

  """
  def list_controllers do
    Repo.all(Controller)
  end

  @doc """
  Gets a single controller.

  Raises `Ecto.NoResultsError` if the Controller does not exist.

  ## Examples

      iex> get_controller!(123)
      %Controller{}

      iex> get_controller!(456)
      ** (Ecto.NoResultsError)

  """
  def get_controller!(id), do: Repo.get!(Controller, id)

  @doc """
  Creates a controller.

  ## Examples

      iex> create_controller(%{field: value})
      {:ok, %Controller{}}

      iex> create_controller(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_controller(attrs \\ %{}) do
    %Controller{}
    |> Controller.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a controller.

  ## Examples

      iex> update_controller(controller, %{field: new_value})
      {:ok, %Controller{}}

      iex> update_controller(controller, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_controller(%Controller{} = controller, attrs) do
    controller
    |> Controller.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Controller.

  ## Examples

      iex> delete_controller(controller)
      {:ok, %Controller{}}

      iex> delete_controller(controller)
      {:error, %Ecto.Changeset{}}

  """
  def delete_controller(%Controller{} = controller) do
    Repo.delete(controller)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking controller changes.

  ## Examples

      iex> change_controller(controller)
      %Ecto.Changeset{source: %Controller{}}

  """
  def change_controller(%Controller{} = controller) do
    Controller.changeset(controller, %{})
  end

  alias Servantex.DeviceManager.Device

  @doc """
  Returns the list of devices.

  ## Examples

      iex> list_devices()
      [%Device{}, ...]

  """
  def list_devices do
    Repo.all(Device)
  end

  @doc """
  Gets a single device.

  Raises `Ecto.NoResultsError` if the Device does not exist.

  ## Examples

      iex> get_device!(123)
      %Device{}

      iex> get_device!(456)
      ** (Ecto.NoResultsError)

  """
  def get_device!(id), do: Repo.get!(Device, id)

  @doc """
  Creates a device.

  ## Examples

      iex> create_device(%{field: value})
      {:ok, %Device{}}

      iex> create_device(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_device(attrs \\ %{}) do
    %Device{}
    |> Device.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a device.

  ## Examples

      iex> update_device(device, %{field: new_value})
      {:ok, %Device{}}

      iex> update_device(device, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_device(%Device{} = device, attrs) do
    device
    |> Device.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Device.

  ## Examples

      iex> delete_device(device)
      {:ok, %Device{}}

      iex> delete_device(device)
      {:error, %Ecto.Changeset{}}

  """
  def delete_device(%Device{} = device) do
    Repo.delete(device)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking device changes.

  ## Examples

      iex> change_device(device)
      %Ecto.Changeset{source: %Device{}}

  """
  def change_device(%Device{} = device) do
    Device.changeset(device, %{})
  end

  alias Servantex.DeviceManager.DeviceControl

  @doc """
  Returns the list of device_controls.

  ## Examples

      iex> list_device_controls()
      [%DeviceControl{}, ...]

  """
  def list_device_controls do
    Repo.all(DeviceControl)
  end

  @doc """
  Gets a single device_control.

  Raises `Ecto.NoResultsError` if the Device control does not exist.

  ## Examples

      iex> get_device_control!(123)
      %DeviceControl{}

      iex> get_device_control!(456)
      ** (Ecto.NoResultsError)

  """
  def get_device_control!(id), do: Repo.get!(DeviceControl, id)

  @doc """
  Creates a device_control.

  ## Examples

      iex> create_device_control(%{field: value})
      {:ok, %DeviceControl{}}

      iex> create_device_control(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_device_control(attrs \\ %{}) do
    %DeviceControl{}
    |> DeviceControl.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a device_control.

  ## Examples

      iex> update_device_control(device_control, %{field: new_value})
      {:ok, %DeviceControl{}}

      iex> update_device_control(device_control, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_device_control(%DeviceControl{} = device_control, attrs) do
    device_control
    |> DeviceControl.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a DeviceControl.

  ## Examples

      iex> delete_device_control(device_control)
      {:ok, %DeviceControl{}}

      iex> delete_device_control(device_control)
      {:error, %Ecto.Changeset{}}

  """
  def delete_device_control(%DeviceControl{} = device_control) do
    Repo.delete(device_control)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking device_control changes.

  ## Examples

      iex> change_device_control(device_control)
      %Ecto.Changeset{source: %DeviceControl{}}

  """
  def change_device_control(%DeviceControl{} = device_control) do
    DeviceControl.changeset(device_control, %{})
  end

  @doc """
  Checks authentication of a controller.

  Returns `{:valid, user_id, controller_id}` in case of success, `:not_authenticated` in case of failure.
  """
  def check_controller_auth(user_id, controller_secret) do
    query =
      from c in Controller,
        where: c.secret == ^controller_secret and c.user_id == ^user_id

    case Repo.one(query) do
      nil ->
        :not_authenticated

      controller ->
        {:valid, controller.user_id, controller.id}
    end
  end

  @doc "Returns the id of the device owner"
  def get_device_owner_id(device_id) do
    query =
      from d in Device,
        where: d.id == ^device_id,
        select: d.user_id

    Repo.one(query)
  end

  @doc """
  Returns extras field of a controller
  """
  def get_controller_extras(controller_id) do
    query =
      from c in Controller,
        where: c.id == ^controller_id,
        select: c.extras

    Repo.one(query)
  end

  @doc """
  Returns `status` field fom `extras` field of a controller.
  """
  def get_controller_status(controller_id) do
    extras = get_controller_extras(controller_id)
    extras["status"] || %{}
  end

  @doc """
  Lists users devices that are enabled.
  """
  def list_user_devices(user_id) do
    query =
      from d in Device,
        where: d.user_id == ^user_id and d.is_enabled

    Repo.all(query)
  end

  @doc """
  Returns current status information of device.
  """
  def get_device_status(user_id, device_id) do
    query =
      from d in Device,
        where: d.id == ^device_id and d.user_id == ^user_id

    device = Repo.one!(query)

    traits = get_device_traits(device.id)

    device_status =
      for trait <- traits do
        get_trait_status(trait)
      end

    Enum.reduce(device_status, %{}, fn x, acc -> Map.merge(x, acc) end)
  end

  @doc """
  Lists DeviceControlls of a specific device.
  """
  def get_device_traits(device_id) do
    query =
      from d in DeviceControl,
        where: d.device_id == ^device_id

    Repo.all(query)
  end

  @doc """
  Lists google traits of a device.
  """
  def list_device_traits(device_id) do
    query =
      from d in DeviceControl,
        where: d.device_id == ^device_id,
        select: d.trait

    Repo.all(query)
  end

  @doc """
  Fetches status of a given DeviceControll (Trait)

  Currently supports:
  - OnOff
  """
  def get_trait_status(%DeviceControl{
        trait: "action.devices.traits.OnOff",
        controller_id: controller_id,
        action: %{
          "pin" => pin_number,
          "on" => %{"value" => on_value},
          "off" => %{"value" => off_value}
        }
      }) do
    pin_number = to_string(pin_number)
    %{^pin_number => status} = get_controller_status(controller_id)

    case status do
      %{"value" => ^on_value} ->
        %{"on" => true}

      %{"value" => ^off_value} ->
        %{"on" => false}

      %{"value" => _undefined} ->
        %{"error" => "bad value"}
    end
  end

  @doc """
  Applies a trait command on a device.
  """
  def apply_trait_action(device_id, command, params) do
    trait = @command_trait[command]

    query =
      from d in DeviceControl,
        where: d.device_id == ^device_id and d.trait == ^trait

    traits = Repo.all(query)

    for device_trait <- traits do
      do_apply_trait_action(device_trait, params)
    end
  end

  @doc """
  Applies the specific trait action of a command.
  """
  def do_apply_trait_action(
        %DeviceControl{
          trait: "action.devices.traits.OnOff",
          controller_id: controller_id,
          action: %{"pin" => pin_number, "on" => on_value, "off" => off_value}
        },
        %{"on" => on_off_state}
      ) do
    value =
      case on_off_state do
        true -> on_value
        false -> off_value
      end

    set_controller_pin(controller_id, pin_number, value)
  end

  @doc """
  Changes a controller pin state.
  """
  def set_controller_pin(controller_id, pin_number, value) do
    controller = get_controller!(controller_id)

    extras = controller.extras
    status = extras["status"]

    status =
      Map.put(
        status,
        to_string(pin_number),
        Map.put(value, "lock_until", System.system_time(:seconds) + @pin_lock_timeout)
      )

    {:ok, _controller} =
      update_controller(controller, %{extras: Map.put(extras, "status", status)})
  end
end
